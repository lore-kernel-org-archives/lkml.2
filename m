Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab1KHXkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:40:16 -0500
Received: from mtv-iport-4.cisco.com ([173.36.130.15]:35383 "EHLO
	mtv-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1KHXkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:40:14 -0500
X-Files: kprobes_ll_sc_testing.txt : 5985
X-IronPort-AV: E=Sophos;i="4.69,479,1315180800"; 
   d="txt'?scan'208";a="13071159"
Date: Tue, 8 Nov 2011 15:26:42 -0800 (PST)
From: Victor Kamensky <kamensky@cisco.com>
To: David Daney <david.daney@cavium.com>
cc: "manesoni@cisco.com" <manesoni@cisco.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Subject: Re: [PATCH 2/4] MIPS Kprobes: Deny probes on ll/sc instructions
In-Reply-To: <4EB98A8E.4060900@cavium.com>
Message-ID: <Pine.GSO.4.58.1111081504560.10959@infra-view9.cisco.com>
References: <20111108170336.GA16526@cisco.com> <20111108170535.GC16526@cisco.com>
 <4EB98A8E.4060900@cavium.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-162216788-1320794802=:10959"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---559023410-162216788-1320794802=:10959
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi David,

Thank you for your feedback! Please see response inline.

On Tue, 8 Nov 2011, David Daney wrote:

> On 11/08/2011 09:05 AM, Maneesh Soni wrote:
> >
> > From: Maneesh Soni<manesoni@cisco.com>
> >
> > Deny probes on ll/sc instructions for MIPS kprobes
> >
> > As ll/sc instruction are for atomic read-modify-write operations, allowing
> > probes on top of these insturctions is a bad idea.
> >
>
> s/insturctions/instructions/
>
> Not only is it a bad idea, it will probably make them fail 100% of the time.
>
> It is also an equally bad idea to place a probe between any LL and SC
> instructions.  How do you prevent that?

As per below code comment we don't prevent that. There is no way to do
that.

> If you cannot prevent probes between LL and SC, why bother with this at all?

We just trying to be a bit practical here. It is better than nothing,
right? Breakpoint on top of ll/sc simply won't work and that is the fact.
Breakpoint between related pair of ll/sc won't work too, but nothing we
can do about that.

We run into this situation with SystemTap function wildcard based tracing,
as per attached unit test note. Basically SystemTap wildcard probe picked
inline assembler function which had first 'll' instruction and as result
it was spinning there till SystemTap module reached threshold and shut
itself off so code proceeded after that. Note attached unit test presents
simplified version of real issue we run into, so it may look a bit
artificial. Note it is highly unlikely that SystemTap wildcard tracing
would pick up anything between related pair of ll/sc. In order to have
breakpoint between ll/sc user had use 'statement' SystemTap directive and
it would be specifically targeting given address and therefore could be
removed easily. In case of wildcard tracing there is no easy workaround
for user to drop functions that start with 'll'.

Ideally we would want to push this check into SystemTap compile time,
along with check for branch delay slot instruction, but currently in
SystemTap there is no infrastructure that would check instruction opcode
at compile time. I believe that disallowed instruction check in SystemTap
compiler is missing for any CPU. Adding it would be small feature that we
did not have time to pursue.

Thanks,
Victor

> David Daney
>
> > Signed-off-by: Victor Kamensky<kamensky@cisco.com>
> > Signed-off-by: Maneesh Soni<manesoni@cisco.com>
> > ---
> >   arch/mips/kernel/kprobes.c |   31 +++++++++++++++++++++++++++++++
> >   1 files changed, 31 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/mips/kernel/kprobes.c b/arch/mips/kernel/kprobes.c
> > index 9fb1876..0ab1a5f 100644
> > --- a/arch/mips/kernel/kprobes.c
> > +++ b/arch/mips/kernel/kprobes.c
> > @@ -113,6 +113,30 @@ insn_ok:
> >   	return 0;
> >   }
> >
> > +/*
> > + * insn_has_ll_or_sc function checks whether instruction is ll or sc
> > + * one; putting breakpoint on top of atomic ll/sc pair is bad idea;
> > + * so we need to prevent it and refuse kprobes insertion for such
> > + * instructions; cannot do much about breakpoint in the middle of
> > + * ll/sc pair; it is upto user to avoid those places
> > + */
> > +static int __kprobes insn_has_ll_or_sc(union mips_instruction insn)
> > +{
> > +	int ret = 0;
> > +
> > +	switch (insn.i_format.opcode) {
> > +	case ll_op:
> > +	case lld_op:
> > +	case sc_op:
> > +	case scd_op:
> > +		ret = 1;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +	return ret;
> > +}
> > +
> >   int __kprobes arch_prepare_kprobe(struct kprobe *p)
> >   {
> >   	union mips_instruction insn;
> > @@ -121,6 +145,13 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
> >
> >   	insn = p->addr[0];
> >
> > +	if (insn_has_ll_or_sc(insn)) {
> > +		pr_notice("Kprobes for ll and sc instructions are not"
> > +			  "supported\n");
> > +		ret = -EINVAL;
> > +		goto out;
> > +	}
> > +
> >   	if (insn_has_delayslot(insn)) {
> >   		pr_notice("Kprobes for branch and jump instructions are not"
> >   			  "supported\n");
>
>
---559023410-162216788-1320794802=:10959
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="kprobes_ll_sc_testing.txt"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.GSO.4.58.1111081526420.10959@infra-view9.cisco.com>
Content-Description: 
Content-Disposition: attachment; filename="kprobes_ll_sc_testing.txt"

S2VybmVsIG1vZHVsZSBzb3VyY2UgDQotLS0tLS0tLS0tLS0tLS0tLS0tLQ0K
DQpzamMtbGRzLTE1NCQgY2F0IE1ha2VmaWxlIA0Kb2JqLW0gOj0gaGVsbG9t
Lm8NCg0KaGVsbG9tLW9ianMgOj0gaGVsbG8ubyBoZWxsbzEubw0KDQpzamMt
bGRzLTE1NCQgY2F0IGhlbGxvLmMgDQojaW5jbHVkZSA8bGludXgvc2NoZWQu
aD4NCiNpbmNsdWRlIDxsaW51eC9waWQuaD4NCiNpbmNsdWRlIDxsaW51eC9l
cnIuaD4NCiNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCiNpbmNsdWRlIDxs
aW51eC9lcnJuby5oPg0KI2luY2x1ZGUgPGxpbnV4L2t0aHJlYWQuaD4NCg0K
TU9EVUxFX0RFU0NSSVBUSU9OKCJzaW1wbGUgaGVsbG8gd29ybGQgbW9kdWxl
Iik7DQpNT0RVTEVfTElDRU5TRSgiR1BMIik7DQoNCnN0YXRpYyBzdHJ1Y3Qg
dGFza19zdHJ1Y3QgKm15X2t0aHJlYWQ7DQppbnQgY291bnRfZG93biA9IDEw
MDsNCg0KDQp2b2lkIHByaW50X3ZhbHVlIChpbnQgaSkNCnsNCiAgICBwcmlu
dGsoInByaW50X3ZhbHVlIHJlY2VpdmVkICVkXG4iLCBpKTsNCn0NCg0KdW5z
aWduZWQgaW50IGJhcjsNCg0Kdm9pZCBkb19hdG9taWNfdGhpbmdzICh1bnNp
Z25lZCBpbnQgaSwgdW5zaWduZWQgaW50ICpwKTsNCg0Kdm9pZCBmb28gKGlu
dCBtYXNrKQ0Kew0KICAgIGRvX2F0b21pY190aGluZ3MoMSwgJmJhcik7DQoN
CiAgICBpZiAobWFzayAmIDB4MSkgew0KICAgICAgICBwcmludF92YWx1ZSg1
KTsNCiAgICB9IGVsc2UgaWYgKG1hc2sgJiAweDIpIHsNCiAgICAgICAgcHJp
bnRfdmFsdWUoNCk7DQogICAgfSBlbHNlIGlmIChtYXNrICYgMHg0KSB7DQog
ICAgICAgIHByaW50X3ZhbHVlKDMpOw0KICAgIH0gZWxzZSBpZiAobWFzayAm
ICgweDggfCAweDEwKSkgew0KICAgICAgICBwcmludF92YWx1ZSgyKTsNCiAg
ICB9DQp9DQoNCg0KaW50DQpoZWxsb21fc3RhcnRfZnVuYzEgKGludCBwKQ0K
ew0KICBwcmludGsoImhlbGxvbTogJXMgY2FsbGVkLCBwID0gJWRcbiIsIF9f
RlVOQ1RJT05fXywgcCk7DQogIGZvbyhwKTsNCiAgcmV0dXJuIHAgKiBwOw0K
fQ0KDQppbnQNCmhlbGxvbV9zdGFydF9mdW5jMiAoaW50IHApDQp7DQogIHBy
aW50aygiaGVsbG9tOiAlcyBjYWxsZWQsIHAgPSAlZFxuIiwgX19GVU5DVElP
Tl9fLCBwKTsNCiAgcmV0dXJuIGhlbGxvbV9zdGFydF9mdW5jMShwKTsNCn0N
Cg0KaW50DQpoZWxsb21fc3RhcnRfZnVuYzMgKGludCBwKQ0Kew0KICBwcmlu
dGsoImhlbGxvbTogJXMgY2FsbGVkLCBwID0gJWRcbiIsIF9fRlVOQ1RJT05f
XywgcCk7DQogIHJldHVybiBoZWxsb21fc3RhcnRfZnVuYzIocCk7DQp9DQoN
CnN0YXRpYyBpbnQNCm15dGhyZWFkKHZvaWQgKmFyZykNCnsNCiAgICB3aGls
ZSAoIWt0aHJlYWRfc2hvdWxkX3N0b3AoKSkgew0KICAgICAgICBwcmludGso
Im15dGhyZWFkIHdha2V1cDogY291bnRfZG91biA9ICVkXG4iLCBjb3VudF9k
b3duKTsNCiAgICAgICAgc2NoZWR1bGVfdGltZW91dF9pbnRlcnJ1cHRpYmxl
KDMgKiBIWik7DQogICAgICAgIGNvdW50X2Rvd24tLTsNCiAgICAgICAgaGVs
bG9tX3N0YXJ0X2Z1bmMzKGNvdW50X2Rvd24pOw0KICAgIH0NCiAgICByZXR1
cm4gMDsNCn0NCg0Kdm9pZA0KY3JlYXRlX215dGhyZWFkICh2b2lkKQ0Kew0K
ICAgbXlfa3RocmVhZCA9IGt0aHJlYWRfcnVuKG15dGhyZWFkLCBOVUxMLCAi
aGVsbG8iKTsNCn0NCg0Kc3RhdGljIGludCBfX2luaXQgaW5pdF9oZWxsbyh2
b2lkKQ0Kew0KICBwcmludGsoImhlbGxvIG1vZHVsZSBsb2FkZWRcbiIpOw0K
ICBjcmVhdGVfbXl0aHJlYWQoKTsNCiAgaGVsbG9tX3N0YXJ0X2Z1bmMzKDUp
Ow0KICANCiAgcmV0dXJuIDA7DQp9DQoNCg0KaW50DQpoZWxsb21fZW5kX2Z1
bmMxIChpbnQgcCkNCnsNCiAgcHJpbnRrKCJoZWxsb206ICVzIGNhbGxlZCwg
cCA9ICVkXG4iLCBfX0ZVTkNUSU9OX18sIHApOw0KICByZXR1cm4gcCAqIHA7
DQp9DQoNCmludA0KaGVsbG9tX2VuZF9mdW5jMiAoaW50IHApDQp7DQogIHBy
aW50aygiaGVsbG9tOiAlcyBjYWxsZWQsIHAgPSAlZFxuIiwgX19GVU5DVElP
Tl9fLCBwKTsNCiAgcmV0dXJuIGhlbGxvbV9lbmRfZnVuYzEocCk7DQp9DQoN
Cg0KaW50DQpoZWxsb21fZW5kX2Z1bmMzIChpbnQgcCkNCnsNCiAgcHJpbnRr
KCJoZWxsb206ICVzIGNhbGxlZCwgcCA9ICVkXG4iLCBfX0ZVTkNUSU9OX18s
IHApOw0KICByZXR1cm4gaGVsbG9tX2VuZF9mdW5jMihwKTsNCn0NCg0Kc3Rh
dGljIHZvaWQgX19leGl0IGV4aXRfaGVsbG8odm9pZCkNCnsNCiAgaGVsbG9t
X2VuZF9mdW5jMyg2KTsNCiAgcHJpbnRrKCJoZWxsbyBtb2R1bGUgcmVtb3Zl
ZFxuIik7DQp9DQoNCm1vZHVsZV9pbml0KGluaXRfaGVsbG8pOw0KbW9kdWxl
X2V4aXQoZXhpdF9oZWxsbyk7DQpzamMtbGRzLTE1NCQgY2F0IGhlbGxvMS5j
IA0KDQpzdGF0aWMgX19pbmxpbmVfXw0Kdm9pZCBteV9hdG9taWNfc3ViKHVu
c2lnbmVkIGludCAqcCwgdW5zaWduZWQgaW50IHYpDQp7DQogICAgICAgIHVu
c2lnbmVkIGludCB0ZW1wOw0KDQogICAgICAgIF9fYXNtX18gX192b2xhdGls
ZV9fICgNCiAgICAgICAgICAgICAgICAiLnNldCBwdXNoXG5cdCINCiAgICAg
ICAgICAgICAgICAiLnNldCBub3Jlb3JkZXJcblx0Ig0KICAgICAgICAgICAg
ICAgICIxOlx0bGwgJTAsICUzXG5cdCIgICAgICAgICAgICAgLyogbG9hZCBv
bGQgdmFsdWUgKi8NCiAgICAgICAgICAgICAgICAic3VidSAgICUwLCAlMCwg
JTJcblx0IiAgICAgICAgIC8qIGNhbGN1bGF0ZSBuZXcgdmFsdWUgKi8NCiAg
ICAgICAgICAgICAgICAic2MgICAgICUwLCAlMVxuXHQiICAgICAgICAgICAg
IC8qIGF0dGVtcHQgdG8gc3RvcmUgKi8NCiAgICAgICAgICAgICAgICAiYmVx
eiAgICUwLCAxYlxuXHQiICAgICAgICAgICAgIC8qIHNwaW4gaWYgZmFpbGVk
ICovDQogICAgICAgICAgICAgICAgIm5vcFxuXHQiDQogICAgICAgICAgICAg
ICAgIi5zZXQgcG9wXG5cdCINCiAgICAgICAgICAgICAgICA6ICI9JnIiICh0
ZW1wKSwgIj1tIiAoKnApDQogICAgICAgICAgICAgICAgOiAiciIgKHYpLCAi
bSIgKCpwKQ0KICAgICAgICAgICAgICAgIDogIm1lbW9yeSIpOw0KfQ0KDQoN
CmludCBrMTsNCmludCBrMjsNCmludCBsMTsNCmludCBsMjsNCg0Kdm9pZCBk
b19hdG9taWNfdGhpbmdzICh1bnNpZ25lZCBpbnQgaSwgdW5zaWduZWQgaW50
ICpwKQ0Kew0KICAgIGsxICs9IDE7DQogICAgazIgKz0gMjsNCiAgICBteV9h
dG9taWNfc3ViKHAsIGkpOw0KICAgIGwyIC09IDI7DQogICAgbDEgLT0gMzsN
Cn0NCg0KVHJhY2luZyBTY3JpcHQNCi0tLS0tLS0tLS0tLS0tDQpzamMtbGRz
LTE1NCQgY2F0IGF0b21pY21fZm9vLnN0cA0KcHJvYmUgbW9kdWxlKCJoZWxs
b20iKS5mdW5jdGlvbigiKiIpLmNhbGwgew0KICAgICAgcHJpbnRmICgiJXMg
LT4gJXNcbiIsIHRocmVhZF9pbmRlbnQoMSksIHByb2JlZnVuYygpKQ0KfQ0K
DQpwcm9iZSBtb2R1bGUoImhlbGxvbSIpLmZ1bmN0aW9uKCIqIikucmV0dXJu
IHsNCiAgICAgIHByaW50ZiAoIiVzIDwtICVzXG4iLCB0aHJlYWRfaW5kZW50
KC0xKSwgcHJvYmVmdW5jKCkpDQp9DQoNCnByb2JlIG1vZHVsZSgiaGVsbG9t
IikuZnVuY3Rpb24oIioiKS5pbmxpbmUgew0KICAgICAgcHJpbnRmICgiJXMg
PT4gJXNcbiIsIHRocmVhZF9pbmRlbnQoMSksIHByb2JlZnVuYygpKQ0KICAg
ICAgdGhyZWFkX2luZGVudCgtMSkNCn0NCg0KUnVuIGxvZ3MNCi0tLS0tLS0t
DQoNCldoZW4gc2NyaXB0IGFjdGl2YXRlZCB3aXRob3V0IGZpeGVzIGl0IGtl
ZXBzIHByaW50aW5nIG15X2F0b21pY19zdWINCmZvcmV2ZXI6DQoNCltteTYz
MDA6fl0kIHN0YXBydW4gYXRvbWljbV9mb28ua28NCiAgICAgMCBoZWxsbygz
ODA3KTogLT4gaGVsbG9tX3N0YXJ0X2Z1bmMzDQogICAgMTcgaGVsbG8oMzgw
Nyk6ICAtPiBoZWxsb21fc3RhcnRfZnVuYzINCiAgICAyNSBoZWxsbygzODA3
KTogICAtPiBoZWxsb21fc3RhcnRfZnVuYzENCiAgICAzMyBoZWxsbygzODA3
KTogICAgLT4gZm9vDQogICAgMzkgaGVsbG8oMzgwNyk6ICAgICAtPiBkb19h
dG9taWNfdGhpbmdzDQogICAgNDQgaGVsbG8oMzgwNyk6ICAgICAgPT4gbXlf
YXRvbWljX3N1Yg0KICAgIDUxIGhlbGxvKDM4MDcpOiAgICAgID0+IG15X2F0
b21pY19zdWINCiAgICA1OCBoZWxsbygzODA3KTogICAgICA9PiBteV9hdG9t
aWNfc3ViDQogICAgNjUgaGVsbG8oMzgwNyk6ICAgICAgPT4gbXlfYXRvbWlj
X3N1Yg0KICAgIDcyIGhlbGxvKDM4MDcpOiAgICAgID0+IG15X2F0b21pY19z
dWINCiAgICA3OSBoZWxsbygzODA3KTogICAgICA9PiBteV9hdG9taWNfc3Vi
DQogICAgODYgaGVsbG8oMzgwNyk6ICAgICAgPT4gbXlfYXRvbWljX3N1Yg0K
ICAgIDkzIGhlbGxvKDM4MDcpOiAgICAgID0+IG15X2F0b21pY19zdWINCiAg
IDEwMCBoZWxsbygzODA3KTogICAgICA9PiBteV9hdG9taWNfc3ViDQogICAx
MDcgaGVsbG8oMzgwNyk6ICAgICAgPT4gbXlfYXRvbWljX3N1Yg0KICAgMTE0
IGhlbGxvKDM4MDcpOiAgICAgID0+IG15X2F0b21pY19zdWINCiAgIDEyMSBo
ZWxsbygzODA3KTogICAgICA9PiBteV9hdG9taWNfc3ViDQogICAxMjggaGVs
bG8oMzgwNyk6ICAgICAgPT4gbXlfYXRvbWljX3N1Yg0KLi4uDQoNCg0KQWZ0
ZXIgdGhlIGZpeDoNCg0KW215NjMwMDp+XSQgc3RhcHJ1biBhdG9taWNtX2Zv
by5rbw0KV0FSTklORzogcHJvYmUgbW9kdWxlKCJoZWxsb20iKS5mdW5jdGlv
bigibXlfYXRvbWljX3N1YkAvd3Mva2FtZW5za3ktc2pjL25vdmEvYXRvbWlj
bS9oZWxsbzEuYzozIikuaW5saW5lIChhZGRyZXNzIDB4ZmZmZmZmZmZjMDIx
MjQwOCkgcmVnaXN0cmF0aW9uIGVycm9yIChyYyAtMjIpDQogICAgIDAgaGVs
bG8oNTYwNSk6IC0+IGhlbGxvbV9zdGFydF9mdW5jMw0KICAgIDI0IGhlbGxv
KDU2MDUpOiAgLT4gaGVsbG9tX3N0YXJ0X2Z1bmMyDQogICAgMzMgaGVsbG8o
NTYwNSk6ICAgLT4gaGVsbG9tX3N0YXJ0X2Z1bmMxDQogICAgNDIgaGVsbG8o
NTYwNSk6ICAgIC0+IGZvbw0KICAgIDQ4IGhlbGxvKDU2MDUpOiAgICAgLT4g
ZG9fYXRvbWljX3RoaW5ncw0KICAgIDU0IGhlbGxvKDU2MDUpOiAgICAgPC0g
ZG9fYXRvbWljX3RoaW5ncw0KICAgIDYwIGhlbGxvKDU2MDUpOiAgICAgPT4g
cHJpbnRfdmFsdWUNCiAgICA2OCBoZWxsbyg1NjA1KTogICAgID0+IHByaW50
X3ZhbHVlDQogICAgNzcgaGVsbG8oNTYwNSk6ICAgIDwtIGZvbw0KICAgIDgy
IGhlbGxvKDU2MDUpOiAgIDwtIGhlbGxvbV9zdGFydF9mdW5jMQ0KICAgIDg2
IGhlbGxvKDU2MDUpOiAgPC0gaGVsbG9tX3N0YXJ0X2Z1bmMyDQogICAgOTAg
aGVsbG8oNTYwNSk6IDwtIGhlbGxvbV9zdGFydF9mdW5jMw0KICAgICAwIGhl
bGxvKDU2MDUpOiAtPiBoZWxsb21fc3RhcnRfZnVuYzMNCiAgICAyMyBoZWxs
byg1NjA1KTogIC0+IGhlbGxvbV9zdGFydF9mdW5jMg0KICAgIDMyIGhlbGxv
KDU2MDUpOiAgIC0+IGhlbGxvbV9zdGFydF9mdW5jMQ0KICAgIDQxIGhlbGxv
KDU2MDUpOiAgICAtPiBmb28NCiAgICA0NiBoZWxsbyg1NjA1KTogICAgIC0+
IGRvX2F0b21pY190aGluZ3MNCiAgICA1MyBoZWxsbyg1NjA1KTogICAgIDwt
IGRvX2F0b21pY190aGluZ3MNCiAgICA1OSBoZWxsbyg1NjA1KTogICAgID0+
IHByaW50X3ZhbHVlDQogICAgNjYgaGVsbG8oNTYwNSk6ICAgICA9PiBwcmlu
dF92YWx1ZQ0KICAgIDc1IGhlbGxvKDU2MDUpOiAgICA8LSBmb28NCiAgICA4
MCBoZWxsbyg1NjA1KTogICA8LSBoZWxsb21fc3RhcnRfZnVuYzENCiAgICA4
NCBoZWxsbyg1NjA1KTogIDwtIGhlbGxvbV9zdGFydF9mdW5jMg0KICAgIDg5
IGhlbGxvKDU2MDUpOiA8LSBoZWxsb21fc3RhcnRfZnVuYzMNCg0KZnJvbSBk
bWVncw0KDQphdG9taWNtX2Zvbzogc3lzdGVtdGFwOiAxLjQvMC4xNTIsIGJh
c2U6IGZmZmZmZmZmYzAyMTgwMDAsIG1lbW9yeTogMjNkYXRhLzI4dGV4dC81
OGN0eC8xM25ldC8yNjJhbGxvYyBrYiwgcHJvYmVzOiAyNw0KS3Byb2JlcyBm
b3IgbGwgYW5kIHNjIGluc3RydWN0aW9ucyBhcmUgbm90IHN1cHBvcnRlZA0K

---559023410-162216788-1320794802=:10959--
