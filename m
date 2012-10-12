Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab2JLDKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 23:10:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:17523 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab2JLDKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 23:10:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="233010587"
From: "Ma, Ling" <ling.ma@intel.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
 instruction sequence and saving register
Thread-Topic: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
 instruction sequence and saving register
Thread-Index: AQHNp3KHe7EK2OTz7EWBVGWon0YSZpe0HToigADK2YA=
Date: Fri, 12 Oct 2012 03:10:45 +0000
Message-ID: <B2310DA9850C8743AA7AA0055500E90F0FD709C4@SHSMSX102.ccr.corp.intel.com>
References: <1349958548-1868-1-git-send-email-ling.ma@intel.com>
 <m2bog9t9cr.fsf@firstfloor.org>
In-Reply-To: <m2bog9t9cr.fsf@firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_B2310DA9850C8743AA7AA0055500E90F0FD709C4SHSMSX102ccrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_B2310DA9850C8743AA7AA0055500E90F0FD709C4SHSMSX102ccrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> > Load and write operation occupy about 35% and 10% respectively for
> > most industry benchmarks. Fetched 16-aligned bytes code include about
> > 4 instructions, implying 1.34(0.35 * 4) load, 0.4 write.
> > Modern CPU support 2 load and 1 write per cycle, so throughput from
> > write is bottleneck for memcpy or copy_page, and some slight CPU only
> > support one mem operation per cycle. So it is enough to issue one
> read
> > and write instruction per cycle, and we can save registers.
>=20
> I don't think "saving registers" is a useful goal here.

Ling: issuing one read and write ops in one cycle is enough for copy_page o=
r memcpy performance,
so we could avoid saving and restoring registers operation.

> >
> > In this patch we also re-arrange instruction sequence to improve
> > performance The performance on atom is improved about 11%, 9% on
> > hot/cold-cache case respectively.
>=20
> That's great, but the question is what happened to the older CPUs that
> also this sequence. It may be safer to add a new variant for Atom,
> unless you can benchmark those too.

Ling:=20
I tested new and original version on core2, the patch improved performance =
about 9%,
Although core2 is out-of-order pipeline and weaken instruction sequence req=
uirement,=20
because of ROB size limitation, new patch issues write operation earlier an=
d
get more parallelism possibility for the pair of write and load ops and bet=
ter result.
Attached core2-cpu-info (I have no older machine)


Thanks
Ling

=20

--_002_B2310DA9850C8743AA7AA0055500E90F0FD709C4SHSMSX102ccrcor_
Content-Type: application/octet-stream; name="core2-cpu-info"
Content-Description: core2-cpu-info
Content-Disposition: attachment; filename="core2-cpu-info"; size=2992;
	creation-date="Fri, 12 Oct 2012 03:03:13 GMT";
	modification-date="Fri, 12 Oct 2012 03:03:07 GMT"
Content-Transfer-Encoding: base64

cHJvY2Vzc29yCTogMAp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9k
ZWwJCTogMTUKbW9kZWwgbmFtZQk6IEludGVsKFIpIENvcmUoVE0pMiBRdWFkIENQVSAgICBRNjYw
MCAgQCAyLjQwR0h6CnN0ZXBwaW5nCTogMTEKY3B1IE1IegkJOiAyNDAwLjAwMwpjYWNoZSBzaXpl
CTogNDA5NiBLQgpwaHlzaWNhbCBpZAk6IDAKc2libGluZ3MJOiA0CmNvcmUgaWQJCTogMApjcHUg
Y29yZXMJOiA0CmFwaWNpZAkJOiAwCmluaXRpYWwgYXBpY2lkCTogMApmcHUJCTogeWVzCmZwdV9l
eGNlcHRpb24JOiB5ZXMKY3B1aWQgbGV2ZWwJOiAxMAp3cAkJOiB5ZXMKZmxhZ3MJCTogZnB1IHZt
ZSBkZSBwc2UgdHNjIG1zciBwYWUgbWNlIGN4OCBhcGljIHNlcCBtdHJyIHBnZSBtY2EgY21vdiBw
YXQgcHNlMzYgY2xmbHVzaCBkdHMgYWNwaSBtbXggZnhzciBzc2Ugc3NlMiBzcyBodCB0bSBwYmUg
c3lzY2FsbCBueCBsbSBjb25zdGFudF90c2MgYXJjaF9wZXJmbW9uIHBlYnMgYnRzIHJlcF9nb29k
IGFwZXJmbXBlcmYgcG5pIGR0ZXM2NCBtb25pdG9yIGRzX2NwbCB2bXggZXN0IHRtMiBzc3NlMyBj
eDE2IHh0cHIgcGRjbSBsYWhmX2xtIHRwcl9zaGFkb3cgdm5taSBmbGV4cHJpb3JpdHkKYm9nb21p
cHMJOiA0Nzg4LjEzCmNsZmx1c2ggc2l6ZQk6IDY0CmNhY2hlX2FsaWdubWVudAk6IDY0CmFkZHJl
c3Mgc2l6ZXMJOiAzNiBiaXRzIHBoeXNpY2FsLCA0OCBiaXRzIHZpcnR1YWwKcG93ZXIgbWFuYWdl
bWVudDoKCnByb2Nlc3Nvcgk6IDEKdmVuZG9yX2lkCTogR2VudWluZUludGVsCmNwdSBmYW1pbHkJ
OiA2Cm1vZGVsCQk6IDE1Cm1vZGVsIG5hbWUJOiBJbnRlbChSKSBDb3JlKFRNKTIgUXVhZCBDUFUg
ICAgUTY2MDAgIEAgMi40MEdIegpzdGVwcGluZwk6IDExCmNwdSBNSHoJCTogMjQwMC4wMDMKY2Fj
aGUgc2l6ZQk6IDQwOTYgS0IKcGh5c2ljYWwgaWQJOiAwCnNpYmxpbmdzCTogNApjb3JlIGlkCQk6
IDEKY3B1IGNvcmVzCTogNAphcGljaWQJCTogMQppbml0aWFsIGFwaWNpZAk6IDEKZnB1CQk6IHll
cwpmcHVfZXhjZXB0aW9uCTogeWVzCmNwdWlkIGxldmVsCTogMTAKd3AJCTogeWVzCmZsYWdzCQk6
IGZwdSB2bWUgZGUgcHNlIHRzYyBtc3IgcGFlIG1jZSBjeDggYXBpYyBzZXAgbXRyciBwZ2UgbWNh
IGNtb3YgcGF0IHBzZTM2IGNsZmx1c2ggZHRzIGFjcGkgbW14IGZ4c3Igc3NlIHNzZTIgc3MgaHQg
dG0gcGJlIHN5c2NhbGwgbnggbG0gY29uc3RhbnRfdHNjIGFyY2hfcGVyZm1vbiBwZWJzIGJ0cyBy
ZXBfZ29vZCBhcGVyZm1wZXJmIHBuaSBkdGVzNjQgbW9uaXRvciBkc19jcGwgdm14IGVzdCB0bTIg
c3NzZTMgY3gxNiB4dHByIHBkY20gbGFoZl9sbSB0cHJfc2hhZG93IHZubWkgZmxleHByaW9yaXR5
CmJvZ29taXBzCTogNDc4Ny43NgpjbGZsdXNoIHNpemUJOiA2NApjYWNoZV9hbGlnbm1lbnQJOiA2
NAphZGRyZXNzIHNpemVzCTogMzYgYml0cyBwaHlzaWNhbCwgNDggYml0cyB2aXJ0dWFsCnBvd2Vy
IG1hbmFnZW1lbnQ6Cgpwcm9jZXNzb3IJOiAyCnZlbmRvcl9pZAk6IEdlbnVpbmVJbnRlbApjcHUg
ZmFtaWx5CTogNgptb2RlbAkJOiAxNQptb2RlbCBuYW1lCTogSW50ZWwoUikgQ29yZShUTSkyIFF1
YWQgQ1BVICAgIFE2NjAwICBAIDIuNDBHSHoKc3RlcHBpbmcJOiAxMQpjcHUgTUh6CQk6IDI0MDAu
MDAzCmNhY2hlIHNpemUJOiA0MDk2IEtCCnBoeXNpY2FsIGlkCTogMApzaWJsaW5ncwk6IDQKY29y
ZSBpZAkJOiAyCmNwdSBjb3Jlcwk6IDQKYXBpY2lkCQk6IDIKaW5pdGlhbCBhcGljaWQJOiAyCmZw
dQkJOiB5ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEwCndwCQk6IHllcwpm
bGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIg
cGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2Uy
IHNzIGh0IHRtIHBiZSBzeXNjYWxsIG54IGxtIGNvbnN0YW50X3RzYyBhcmNoX3BlcmZtb24gcGVi
cyBidHMgcmVwX2dvb2QgYXBlcmZtcGVyZiBwbmkgZHRlczY0IG1vbml0b3IgZHNfY3BsIHZteCBl
c3QgdG0yIHNzc2UzIGN4MTYgeHRwciBwZGNtIGxhaGZfbG0gdHByX3NoYWRvdyB2bm1pIGZsZXhw
cmlvcml0eQpib2dvbWlwcwk6IDQ3ODcuNzgKY2xmbHVzaCBzaXplCTogNjQKY2FjaGVfYWxpZ25t
ZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDM2IGJpdHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVh
bApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29yCTogMwp2ZW5kb3JfaWQJOiBHZW51aW5lSW50
ZWwKY3B1IGZhbWlseQk6IDYKbW9kZWwJCTogMTUKbW9kZWwgbmFtZQk6IEludGVsKFIpIENvcmUo
VE0pMiBRdWFkIENQVSAgICBRNjYwMCAgQCAyLjQwR0h6CnN0ZXBwaW5nCTogMTEKY3B1IE1IegkJ
OiAyNDAwLjAwMwpjYWNoZSBzaXplCTogNDA5NiBLQgpwaHlzaWNhbCBpZAk6IDAKc2libGluZ3MJ
OiA0CmNvcmUgaWQJCTogMwpjcHUgY29yZXMJOiA0CmFwaWNpZAkJOiAzCmluaXRpYWwgYXBpY2lk
CTogMwpmcHUJCTogeWVzCmZwdV9leGNlcHRpb24JOiB5ZXMKY3B1aWQgbGV2ZWwJOiAxMAp3cAkJ
OiB5ZXMKZmxhZ3MJCTogZnB1IHZtZSBkZSBwc2UgdHNjIG1zciBwYWUgbWNlIGN4OCBhcGljIHNl
cCBtdHJyIHBnZSBtY2EgY21vdiBwYXQgcHNlMzYgY2xmbHVzaCBkdHMgYWNwaSBtbXggZnhzciBz
c2Ugc3NlMiBzcyBodCB0bSBwYmUgc3lzY2FsbCBueCBsbSBjb25zdGFudF90c2MgYXJjaF9wZXJm
bW9uIHBlYnMgYnRzIHJlcF9nb29kIGFwZXJmbXBlcmYgcG5pIGR0ZXM2NCBtb25pdG9yIGRzX2Nw
bCB2bXggZXN0IHRtMiBzc3NlMyBjeDE2IHh0cHIgcGRjbSBsYWhmX2xtIHRwcl9zaGFkb3cgdm5t
aSBmbGV4cHJpb3JpdHkKYm9nb21pcHMJOiA0Nzg3Ljc2CmNsZmx1c2ggc2l6ZQk6IDY0CmNhY2hl
X2FsaWdubWVudAk6IDY0CmFkZHJlc3Mgc2l6ZXMJOiAzNiBiaXRzIHBoeXNpY2FsLCA0OCBiaXRz
IHZpcnR1YWwKcG93ZXIgbWFuYWdlbWVudDoKCg==

--_002_B2310DA9850C8743AA7AA0055500E90F0FD709C4SHSMSX102ccrcor_--
