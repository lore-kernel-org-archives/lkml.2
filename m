Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab1BEQqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 11:46:47 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:35413 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab1BEQqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 11:46:46 -0500
Message-ID: <1296924395.4d4d7eeb6f1fe@imp.free.fr>
Date: Sat, 05 Feb 2011 17:46:35 +0100
From: castet.matthieu@free.fr
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, castet.matthieu@free.fr,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
References: <4D473FD5.1090903@free.fr> <20110201080223.GB20372@elte.hu> <1296566732.4d4809cc1f963@imp.free.fr> <20110202062632.GA12256@elte.hu> <4D4CA3FD.6000901@zytor.com>
In-Reply-To: <4D4CA3FD.6000901@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-MOQ12969243955b2cc932ebeaa8ea44973784a10f71f5"
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 81.57.151.96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format.

---MOQ12969243955b2cc932ebeaa8ea44973784a10f71f5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Selon "H. Peter Anvin" <hpa@zytor.com>:

> On 02/01/2011 10:26 PM, Ingo Molnar wrote:
> >
> > So why not call set_memory_x() in your patch? Mind trying that?
> >
> > Thanks,
> >
> > 	Ingo
>
> So I just tried that... it doesn't work.  The resulting pages still end
> up NX:
>
> ---[ Kernel Mapping ]---
> 0xc0000000-0xc00a0000         640K     RW             GLB NX pte
>
> This implies that the NX protection is applied after these allocations
> happen, which is probably why the ugly hack in static_protections() to
> set the PCI BIOS +x is there as well.
You could remove PCI BIOS +x hack in static protection, and the x mapping will
be set by set_memory_x().

The problem is that acpi_reserve_wakeup_memory is called too early, before we
build the page table with kernel_physical_mapping_init.

Doing the setting in a arch_initcall make it work.

>
> I talked to Suresh about the whole static_protections() bit, and as far
> as he recalls it is because the entire set_memory_*() interface is
> misdesigned to work on all aliases of a page, despite the fact that
> protections are per mapping, not per physical page.
The only stuff I understood of static_protections is the comment on top of it :
mapping of bios/kernel region should be on it otherwise, some callers can mess
the protection flags.


Matthieu
---MOQ12969243955b2cc932ebeaa8ea44973784a10f71f5
Content-Type: application/octet-stream; name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9hY3BpL3NsZWVwLmMgYi9hcmNoL3g4Ni9rZXJu
ZWwvYWNwaS9zbGVlcC5jCmluZGV4IDY5ZmQ3MmEuLjFmZGU2ZWMgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9hY3BpL3NsZWVwLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2FjcGkvc2xlZXAu
YwpAQCAtMTUsNiArMTUsNyBAQAogCiAjaWZkZWYgQ09ORklHX1g4Nl8zMgogI2luY2x1ZGUgPGFz
bS9wZ3RhYmxlLmg+CisjaW5jbHVkZSA8YXNtL2NhY2hlZmx1c2guaD4KICNlbmRpZgogCiAjaW5j
bHVkZSAicmVhbG1vZGUvd2FrZXVwLmgiCkBAIC0xNDksNiArMTUwLDE1IEBAIHZvaWQgX19pbml0
IGFjcGlfcmVzZXJ2ZV93YWtldXBfbWVtb3J5KHZvaWQpCiAJbWVtYmxvY2tfeDg2X3Jlc2VydmVf
cmFuZ2UobWVtLCBtZW0gKyBXQUtFVVBfU0laRSwgIkFDUEkgV0FLRVVQIik7CiB9CiAKKyNpZmRl
ZiBDT05GSUdfWDg2XzMyCitpbnQgX19pbml0IGFjcGlfY29uZmlndXJlX3dha2V1cF9tZW1vcnko
dm9pZCkKK3sKKwlzZXRfbWVtb3J5X3goYWNwaV9yZWFsbW9kZSwgKFdBS0VVUF9TSVpFKSA+PiBQ
QUdFX1NISUZUKTsKKwlyZXR1cm4gMDsKK30KK2FyY2hfaW5pdGNhbGwoYWNwaV9jb25maWd1cmVf
d2FrZXVwX21lbW9yeSk7CisjZW5kaWYKKwogCiBzdGF0aWMgaW50IF9faW5pdCBhY3BpX3NsZWVw
X3NldHVwKGNoYXIgKnN0cikKIHsK

---MOQ12969243955b2cc932ebeaa8ea44973784a10f71f5--
