Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab1BJUDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 15:03:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756437Ab1BJUDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 15:03:46 -0500
MIME-Version: 1.0
In-Reply-To: <20110210113456.93e8bc56.randy.dunlap@oracle.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <20110209093656.2b23b80b.randy.dunlap@oracle.com> <20110210113456.93e8bc56.randy.dunlap@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Feb 2011 12:03:19 -0800
Message-ID: <AANLkTim5G9x7UKS8f=kcS+u7LgEUYsPCfT8Yk+BiX0we@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc4 (other bugs: ipmi Oops)
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Corey Minyard <minyard@acm.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Content-Type: multipart/mixed; boundary=20cf304346ccdfa1f5049bf3134e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf304346ccdfa1f5049bf3134e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 10, 2011 at 11:34 AM, Randy Dunlap <randy.dunlap@oracle.com> wr=
ote:
>
> Loading ipmi_si module a second time causes an Oops:
>
> [ =A0 68.120143] RIP: 0010:[<ffffffff813fc579>] =A0[<ffffffff813fc579>] p=
ut_driver+0x10/0x22

The disassembly is

  	55                   	push   %rbp
  	48 89 e5             	mov    %rsp,%rbp
  	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  	48 ff 05 c7 af 80 01 	incq   0x180afc7(%rip)        # 0x180aff2
  *	48 8b 7f 60          	mov    0x60(%rdi),%rdi     <-- trapping instructi=
on
  	e8 38 27 ec ff       	callq  0xffffffffffec276c
  	48 ff 05 bf af 80 01 	incq   0x180afbf(%rip)        # 0x180affa
  	c9                   	leaveq
  	c3                   	retq

which is the access of "drv->p" in that function:

   kobject_put(&drv->p->kobj);

so "drv" that was passed in was just bogus. (it's
"0xffffffffa06a8430", looks like it's the DEBUG_PAGEALLOC that has
caused the page to be free'd).

> [ =A0 68.340115] Call Trace:
> [ =A0 68.340115] =A0[<ffffffff813fc64b>] driver_register+0xc0/0x1b2
> [ =A0 68.340115] =A0[<ffffffff8137f5de>] pnp_register_driver+0x28/0x31
> [ =A0 68.340115] =A0[<ffffffffa06b888d>] init_ipmi_si+0x1a4/0x4cd [ipmi_s=
i]
> [ =A0 68.340115] =A0[<ffffffff810020a6>] do_one_initcall+0x6c/0x1e3
> [ =A0 68.340115] =A0[<ffffffff810d4998>] sys_init_module+0x12b/0x307

And I think that - as usual - the problem is that the damn driver
cleanup is very ugly, and has this duplicate set of code to unregister
all the random crap. Except one of the duplicates is missing one case.
I think the bug was introduced by Gjorn Helgaas in commit 9e368fa011d4
("ipmi: add PNP discovery (ACPI namespace via PNPACPI)") which added
the acpi pnp case, but only unregistered it on the regular module exit
path, not on the "module loaded with no pnp devices" path.

Does this patch fix it? And Corey - this is a good example of why the
code shouldn't duplicate the "unregister stuff" in the module load
error case vs the module exit path, and there should be a shared
"cleanup()" function that is called by both. Can this be cleaned up,
please?

PATCH IS UNTESTED!

                         Linus

--20cf304346ccdfa1f5049bf3134e
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gk03iny40

IGRyaXZlcnMvY2hhci9pcG1pL2lwbWlfc2lfaW50Zi5jIHwgICAgNCArKysrCiAxIGZpbGVzIGNo
YW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL2NoYXIvaXBtaS9pcG1pX3NpX2ludGYuYyBiL2RyaXZlcnMvY2hhci9pcG1pL2lwbWlfc2lf
aW50Zi5jCmluZGV4IGI2YWU2ZTkuLjU5NTM4MjUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY2hhci9p
cG1pL2lwbWlfc2lfaW50Zi5jCisrKyBiL2RyaXZlcnMvY2hhci9pcG1pL2lwbWlfc2lfaW50Zi5j
CkBAIC0zNDU0LDYgKzM0NTQsMTAgQEAgc3RhdGljIGludCBfX2RldmluaXQgaW5pdF9pcG1pX3Np
KHZvaWQpCiAJCWlmIChwY2lfcmVnaXN0ZXJlZCkKIAkJCXBjaV91bnJlZ2lzdGVyX2RyaXZlcigm
aXBtaV9wY2lfZHJpdmVyKTsKICNlbmRpZgorI2lmZGVmIENPTkZJR19BQ1BJCisJCWlmIChwbnBf
cmVnaXN0ZXJlZCkKKwkJCXBucF91bnJlZ2lzdGVyX2RyaXZlcigmaXBtaV9wbnBfZHJpdmVyKTsK
KyNlbmRpZgogCiAjaWZkZWYgQ09ORklHX1BQQ19PRgogCQlpZiAob2ZfcmVnaXN0ZXJlZCkK
--20cf304346ccdfa1f5049bf3134e--
