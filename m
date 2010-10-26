Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084Ab0JZQ7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:59:15 -0400
Received: from claw.goop.org ([74.207.240.146]:48670 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab0JZQ7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:59:13 -0400
Message-ID: <4CC708DE.1070000@goop.org>
Date: Tue, 26 Oct 2010 09:59:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Glauber Costa <glommer@redhat.com>, Avi Kivity <avi@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        kvm-devel <kvm@vger.kernel.org>,
        =?UTF-8?B?Q8OpZHJpYyBTY2hpZWxp?= <cschieli@gmail.com>,
        Eelco Dolstra <e.dolstra@tudelft.nl>,
        Olivier Hanesse <olivier.hanesse@gmail.com>
Subject: [PATCH] x86/pvclock-xen: zero last_value on resume
Content-Type: multipart/mixed;
 boundary="------------060608010402050109030205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060608010402050109030205
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



If the guest domain has been suspend/resumed or migrated, then the
system clock backing the pvclock clocksource may revert to a smaller
value (ie, can be non-monotonic across the migration/save-restore).
Make sure we zero last_value in that case so that the domain
continues to see clock updates.

[ I don't know if kvm needs an analogous fix or not. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Stable Kernel <stable@kernel.org>
Reported-by: Eelco Dolstra <e.dolstra@tudelft.nl>
Reported-by: Olivier Hanesse <olivier.hanesse@gmail.com>
Bisected-by: Cédric Schieli <cschieli@gmail.com>
Tested-by: Cédric Schieli <cschieli@gmail.com>

diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index cd02f32..6226870 100644
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -11,5 +11,6 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src);
 void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct pvclock_vcpu_time_info *vcpu,
 			    struct timespec *ts);
+void pvclock_resume(void);
 
 #endif /* _ASM_X86_PVCLOCK_H */
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 239427c..a4f07c1 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -120,6 +120,11 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src)
 
 static atomic64_t last_value = ATOMIC64_INIT(0);
 
+void pvclock_resume(void)
+{
+	atomic64_set(&last_value, 0);
+}
+
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 {
 	struct pvclock_shadow_time shadow;
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index b2bb5aa..5da5e53 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -426,6 +426,8 @@ void xen_timer_resume(void)
 {
 	int cpu;
 
+	pvclock_resume();
+
 	if (xen_clockevent != &xen_vcpuop_clockevent)
 		return;
 



--------------060608010402050109030205
Content-Type: text/plain;
 name="x86-pvclock-resume.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="x86-pvclock-resume.patch"

RnJvbSAyOWFjYmI0ZTFkOTNlNzE5MjUwNjQ4ZGIxY2U4YzdhMjQxNDRmZDg2IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZXJlbXkgRml0emhhcmRpbmdlIDxqZXJlbXkuZml0
emhhcmRpbmdlQGNpdHJpeC5jb20+CkRhdGU6IE1vbiwgMjUgT2N0IDIwMTAgMTY6NTM6NDYg
LTA3MDAKU3ViamVjdDogW1BBVENIXSB4ODYvcHZjbG9jazogemVybyBsYXN0X3ZhbHVlIG9u
IHJlc3VtZQoKSWYgdGhlIGd1ZXN0IGRvbWFpbiBoYXMgYmVlbiBzdXNwZW5kL3Jlc3VtZWQg
b3IgbWlncmF0ZWQsIHRoZW4gdGhlCnN5c3RlbSBjbG9jayBiYWNraW5nIHRoZSBwdmNsb2Nr
IGNsb2Nrc291cmNlIG1heSByZXZlcnQgdG8gYSBzbWFsbGVyCnZhbHVlIChpZSwgY2FuIGJl
IG5vbi1tb25vdG9uaWMgYWNyb3NzIHRoZSBtaWdyYXRpb24vc2F2ZS1yZXN0b3JlKS4KTWFr
ZSBzdXJlIHdlIHplcm8gbGFzdF92YWx1ZSBpbiB0aGF0IGNhc2Ugc28gdGhhdCB0aGUgZG9t
YWluCmNvbnRpbnVlcyB0byBzZWUgY2xvY2sgdXBkYXRlcy4KClNpZ25lZC1vZmYtYnk6IEpl
cmVteSBGaXR6aGFyZGluZ2UgPGplcmVteS5maXR6aGFyZGluZ2VAY2l0cml4LmNvbT4KQ2M6
IFN0YWJsZSBLZXJuZWwgPHN0YWJsZUBrZXJuZWwub3JnPgpSZXBvcnRlZC1ieTogRWVsY28g
RG9sc3RyYSA8ZS5kb2xzdHJhQHR1ZGVsZnQubmw+ClJlcG9ydGVkLWJ5OiBPbGl2aWVyIEhh
bmVzc2UgPG9saXZpZXIuaGFuZXNzZUBnbWFpbC5jb20+CkJpc2VjdGVkLWJ5OiBDw6lkcmlj
IFNjaGllbGkgPGNzY2hpZWxpQGdtYWlsLmNvbT4KVGVzdGVkLWJ5OiBDw6lkcmljIFNjaGll
bGkgPGNzY2hpZWxpQGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9wdmNsb2NrLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9wdmNsb2NrLmgKaW5kZXgg
Y2QwMmYzMi4uNjIyNjg3MCAxMDA2NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcHZj
bG9jay5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3B2Y2xvY2suaApAQCAtMTEsNSAr
MTEsNiBAQCB1bnNpZ25lZCBsb25nIHB2Y2xvY2tfdHNjX2toeihzdHJ1Y3QgcHZjbG9ja192
Y3B1X3RpbWVfaW5mbyAqc3JjKTsKIHZvaWQgcHZjbG9ja19yZWFkX3dhbGxjbG9jayhzdHJ1
Y3QgcHZjbG9ja193YWxsX2Nsb2NrICp3YWxsLAogCQkJICAgIHN0cnVjdCBwdmNsb2NrX3Zj
cHVfdGltZV9pbmZvICp2Y3B1LAogCQkJICAgIHN0cnVjdCB0aW1lc3BlYyAqdHMpOwordm9p
ZCBwdmNsb2NrX3Jlc3VtZSh2b2lkKTsKIAogI2VuZGlmIC8qIF9BU01fWDg2X1BWQ0xPQ0tf
SCAqLwpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL3B2Y2xvY2suYyBiL2FyY2gveDg2
L2tlcm5lbC9wdmNsb2NrLmMKaW5kZXggMjM5NDI3Yy4uYTRmMDdjMSAxMDA2NDQKLS0tIGEv
YXJjaC94ODYva2VybmVsL3B2Y2xvY2suYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvcHZjbG9j
ay5jCkBAIC0xMjAsNiArMTIwLDExIEBAIHVuc2lnbmVkIGxvbmcgcHZjbG9ja190c2Nfa2h6
KHN0cnVjdCBwdmNsb2NrX3ZjcHVfdGltZV9pbmZvICpzcmMpCiAKIHN0YXRpYyBhdG9taWM2
NF90IGxhc3RfdmFsdWUgPSBBVE9NSUM2NF9JTklUKDApOwogCit2b2lkIHB2Y2xvY2tfcmVz
dW1lKHZvaWQpCit7CisJYXRvbWljNjRfc2V0KCZsYXN0X3ZhbHVlLCAwKTsKK30KKwogY3lj
bGVfdCBwdmNsb2NrX2Nsb2Nrc291cmNlX3JlYWQoc3RydWN0IHB2Y2xvY2tfdmNwdV90aW1l
X2luZm8gKnNyYykKIHsKIAlzdHJ1Y3QgcHZjbG9ja19zaGFkb3dfdGltZSBzaGFkb3c7CmRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni94ZW4vdGltZS5jIGIvYXJjaC94ODYveGVuL3RpbWUuYwpp
bmRleCBiMmJiNWFhLi41ZGE1ZTUzIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni94ZW4vdGltZS5j
CisrKyBiL2FyY2gveDg2L3hlbi90aW1lLmMKQEAgLTQyNiw2ICs0MjYsOCBAQCB2b2lkIHhl
bl90aW1lcl9yZXN1bWUodm9pZCkKIHsKIAlpbnQgY3B1OwogCisJcHZjbG9ja19yZXN1bWUo
KTsKKwogCWlmICh4ZW5fY2xvY2tldmVudCAhPSAmeGVuX3ZjcHVvcF9jbG9ja2V2ZW50KQog
CQlyZXR1cm47CiAK
--------------060608010402050109030205--
