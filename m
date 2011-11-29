Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1K2UpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:45:20 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63885 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab1K2UpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:45:17 -0500
MIME-Version: 1.0
In-Reply-To: <1322598920.17003.71.camel@frodo>
References: <1322539673.17003.45.camel@frodo> <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
 <m2r50qlmgk.fsf@firstfloor.org> <1322598920.17003.71.camel@frodo>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 Nov 2011 12:44:55 -0800
X-Google-Sender-Auth: tgtkkJLzSf570Kl8G1EoXGUFDIk
Message-ID: <CA+55aFzgM55hXTs4griX5e9=v_O+=ue+7Rj0PTD=M7hFYpyULQ@mail.gmail.com>
Subject: Re: Perhaps a side effect regarding NMI returns
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Content-Type: multipart/mixed; boundary=f46d04374ad1566bc004b2e5b28f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04374ad1566bc004b2e5b28f
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Nov 29, 2011 at 12:35 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> There may be a problem where you are profiling at a high frequency, and
> then hit this and suddenly, your high frequency NMIs are stopped till
> the next interrupt. If you are running at 100HZ, the next interrupt may
> not happen for 10ms, where we don't have an NMI triggered until then.

It could be much worse than that with no-HZ and some CPU-intensive
load with no timers. I don't think "sysret" enables NMI's either, so
return-to-user-mode may well leave NMI blocked.

So I really think this might be a real issue. And the simplest
approach seems to be to just remove the code. Something like the
attached (TOTALLY UNTESTED!) patch.

Hmm?

                  Linus

--f46d04374ad1566bc004b2e5b28f
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gvldkt940

IGFyY2gveDg2L2tlcm5lbC9lbnRyeV82NC5TIHwgICAzMiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAwIGluc2VydGlvbnMoKyksIDMyIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9lbnRyeV82NC5TIGIvYXJjaC94ODYv
a2VybmVsL2VudHJ5XzY0LlMKaW5kZXggZmFmOGQ1ZTc0YjBiLi4zODE5ZWE5MDczMzkgMTAwNjQ0
Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9lbnRyeV82NC5TCisrKyBiL2FyY2gveDg2L2tlcm5lbC9l
bnRyeV82NC5TCkBAIC0xNDg5LDQ2ICsxNDg5LDE0IEBAIEVOVFJZKG5taSkKIAltb3ZxICVyc3As
JXJkaQogCW1vdnEgJC0xLCVyc2kKIAljYWxsIGRvX25taQotI2lmZGVmIENPTkZJR19UUkFDRV9J
UlFGTEFHUwotCS8qIHBhcmFub2lkZXhpdDsgd2l0aG91dCBUUkFDRV9JUlFTX09GRiAqLwotCS8q
IGVieDoJbm8gc3dhcGdzIGZsYWcgKi8KLQlESVNBQkxFX0lOVEVSUlVQVFMoQ0xCUl9OT05FKQog
CXRlc3RsICVlYngsJWVieAkJCQkvKiBzd2FwZ3MgbmVlZGVkPyAqLwogCWpueiBubWlfcmVzdG9y
ZQotCXRlc3RsICQzLENTKCVyc3ApCi0Jam56IG5taV91c2Vyc3BhY2UKIG5taV9zd2FwZ3M6CiAJ
U1dBUEdTX1VOU0FGRV9TVEFDSwogbm1pX3Jlc3RvcmU6CiAJUkVTVE9SRV9BTEwgOAogCWptcCBp
cnFfcmV0dXJuCi1ubWlfdXNlcnNwYWNlOgotCUdFVF9USFJFQURfSU5GTyglcmN4KQotCW1vdmwg
VElfZmxhZ3MoJXJjeCksJWVieAotCWFuZGwgJF9USUZfV09SS19NQVNLLCVlYngKLQlqeiBubWlf
c3dhcGdzCi0JbW92cSAlcnNwLCVyZGkJCQkvKiAmcHRfcmVncyAqLwotCWNhbGwgc3luY19yZWdz
Ci0JbW92cSAlcmF4LCVyc3AJCQkvKiBzd2l0Y2ggc3RhY2sgZm9yIHNjaGVkdWxpbmcgKi8KLQl0
ZXN0bCAkX1RJRl9ORUVEX1JFU0NIRUQsJWVieAotCWpueiBubWlfc2NoZWR1bGUKLQltb3ZsICVl
YngsJWVkeAkJCS8qIGFyZzM6IHRocmVhZCBmbGFncyAqLwotCUVOQUJMRV9JTlRFUlJVUFRTKENM
QlJfTk9ORSkKLQl4b3JsICVlc2ksJWVzaSAJCQkvKiBhcmcyOiBvbGRzZXQgKi8KLQltb3ZxICVy
c3AsJXJkaSAJCQkvKiBhcmcxOiAmcHRfcmVncyAqLwotCWNhbGwgZG9fbm90aWZ5X3Jlc3VtZQot
CURJU0FCTEVfSU5URVJSVVBUUyhDTEJSX05PTkUpCi0Jam1wIG5taV91c2Vyc3BhY2UKLW5taV9z
Y2hlZHVsZToKLQlFTkFCTEVfSU5URVJSVVBUUyhDTEJSX0FOWSkKLQljYWxsIHNjaGVkdWxlCi0J
RElTQUJMRV9JTlRFUlJVUFRTKENMQlJfQU5ZKQotCWptcCBubWlfdXNlcnNwYWNlCiAJQ0ZJX0VO
RFBST0MKLSNlbHNlCi0Jam1wIHBhcmFub2lkX2V4aXQKLQlDRklfRU5EUFJPQwotI2VuZGlmCiBF
TkQobm1pKQogCiBFTlRSWShpZ25vcmVfc3lzcmV0KQo=
--f46d04374ad1566bc004b2e5b28f--
