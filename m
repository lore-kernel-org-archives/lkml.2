Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1BQRqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:46:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757060Ab1BQRq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:46:28 -0500
MIME-Version: 1.0
In-Reply-To: <20110217173136.GA28486@dtor-ws.eng.vmware.com>
References: <1297123347-2170-1-git-send-email-dtor@vmware.com>
 <AANLkTim_BL_Cw=X0iuatgw1F4n50CyXv0uqx9n=5=Bq+@mail.gmail.com> <20110217173136.GA28486@dtor-ws.eng.vmware.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 09:45:37 -0800
Message-ID: <AANLkTikGVS9EM=7uhwYfXrGHg9yzes7m0pxAinRxivPC@mail.gmail.com>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in module versions
To: Dmitry Torokhov <dtor@vmware.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: multipart/mixed; boundary=90e6ba4fc23c4e4db2049c7df8da
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba4fc23c4e4db2049c7df8da
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Feb 17, 2011 at 9:31 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
>
> From what I understand __attribute__ ((aligned(x))) only guarantees
> minimum alignment, not exact (gapless) alignment. GCC seems to lay out
> pointers in the section without gaps on all arches that we have.

I still don't see the problem.

Have you actually _tried_ just adding the proper alignment to before
the __modver thing in include/asm-generic/vmlinux.lds.h ?

As far as I can tell, the bug is really simple:
 - the section is not aligned
 - but we told the compiler that that structure is aligned

End result: there is a gap between the section start and the first structure.

And the fix seems obvious: just make sure that the section is
sufficiently aligned.

IOW, why isn't the proper fix the obvious trivial one (attached)?

                                    Linus

--90e6ba4fc23c4e4db2049c7df8da
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gk9yob6k0

IGluY2x1ZGUvYXNtLWdlbmVyaWMvdm1saW51eC5sZHMuaCB8ICAgIDIgKysKIDEgZmlsZXMgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1
ZGUvYXNtLWdlbmVyaWMvdm1saW51eC5sZHMuaCBiL2luY2x1ZGUvYXNtLWdlbmVyaWMvdm1saW51
eC5sZHMuaAppbmRleCBmZTc3ZTMzLi4zMWE0YjFkIDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS1n
ZW5lcmljL3ZtbGludXgubGRzLmgKKysrIGIvaW5jbHVkZS9hc20tZ2VuZXJpYy92bWxpbnV4Lmxk
cy5oCkBAIC0zNTgsNiArMzU4LDcgQEAKIAl9CQkJCQkJCQlcCiAJCQkJCQkJCQlcCiAJLyogQnVp
bHQtaW4gbW9kdWxlIHBhcmFtZXRlcnMuICovCQkJCVwKKwlTVFJVQ1RfQUxJR04oKQkJCQkJCQlc
CiAJX19wYXJhbSA6IEFUKEFERFIoX19wYXJhbSkgLSBMT0FEX09GRlNFVCkgewkJCVwKIAkJVk1M
SU5VWF9TWU1CT0woX19zdGFydF9fX3BhcmFtKSA9IC47CQkJXAogCQkqKF9fcGFyYW0pCQkJCQkJ
XApAQCAtMzY1LDYgKzM2Niw3IEBACiAJfQkJCQkJCQkJXAogCQkJCQkJCQkJXAogCS8qIEJ1aWx0
LWluIG1vZHVsZSB2ZXJzaW9ucy4gKi8JCQkJCVwKKwlTVFJVQ1RfQUxJR04oKQkJCQkJCQlcCiAJ
X19tb2R2ZXIgOiBBVChBRERSKF9fbW9kdmVyKSAtIExPQURfT0ZGU0VUKSB7CQkJXAogCQlWTUxJ
TlVYX1NZTUJPTChfX3N0YXJ0X19fbW9kdmVyKSA9IC47CQkJXAogCQkqKF9fbW9kdmVyKQkJCQkJ
CVwK
--90e6ba4fc23c4e4db2049c7df8da--
