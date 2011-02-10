Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab1BJVmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:42:35 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34503 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab1BJVme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:42:34 -0500
Message-ID: <4D545B93.9010109@oracle.com>
Date: Thu, 10 Feb 2011 13:41:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Corey Minyard <minyard@acm.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: Linux 2.6.38-rc4 (other bugs: ipmi Oops)
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com> <20110209093656.2b23b80b.randy.dunlap@oracle.com> <20110210113456.93e8bc56.randy.dunlap@oracle.com> <AANLkTim5G9x7UKS8f=kcS+u7LgEUYsPCfT8Yk+BiX0we@mail.gmail.com>
In-Reply-To: <AANLkTim5G9x7UKS8f=kcS+u7LgEUYsPCfT8Yk+BiX0we@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D545BA2.00EE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/11 12:03, Linus Torvalds wrote:
> On Thu, Feb 10, 2011 at 11:34 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>> Loading ipmi_si module a second time causes an Oops:
>>
>> [   68.120143] RIP: 0010:[<ffffffff813fc579>]  [<ffffffff813fc579>] put_driver+0x10/0x22
> 
> The disassembly is
> 
>   	55                   	push   %rbp
>   	48 89 e5             	mov    %rsp,%rbp
>   	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
>   	48 ff 05 c7 af 80 01 	incq   0x180afc7(%rip)        # 0x180aff2
>   *	48 8b 7f 60          	mov    0x60(%rdi),%rdi     <-- trapping instruction
>   	e8 38 27 ec ff       	callq  0xffffffffffec276c
>   	48 ff 05 bf af 80 01 	incq   0x180afbf(%rip)        # 0x180affa
>   	c9                   	leaveq
>   	c3                   	retq
> 
> which is the access of "drv->p" in that function:
> 
>    kobject_put(&drv->p->kobj);
> 
> so "drv" that was passed in was just bogus. (it's
> "0xffffffffa06a8430", looks like it's the DEBUG_PAGEALLOC that has
> caused the page to be free'd).
> 
>> [   68.340115] Call Trace:
>> [   68.340115]  [<ffffffff813fc64b>] driver_register+0xc0/0x1b2
>> [   68.340115]  [<ffffffff8137f5de>] pnp_register_driver+0x28/0x31
>> [   68.340115]  [<ffffffffa06b888d>] init_ipmi_si+0x1a4/0x4cd [ipmi_si]
>> [   68.340115]  [<ffffffff810020a6>] do_one_initcall+0x6c/0x1e3
>> [   68.340115]  [<ffffffff810d4998>] sys_init_module+0x12b/0x307
> 
> And I think that - as usual - the problem is that the damn driver
> cleanup is very ugly, and has this duplicate set of code to unregister
> all the random crap. Except one of the duplicates is missing one case.
> I think the bug was introduced by Gjorn Helgaas in commit 9e368fa011d4
> ("ipmi: add PNP discovery (ACPI namespace via PNPACPI)") which added
> the acpi pnp case, but only unregistered it on the regular module exit
> path, not on the "module loaded with no pnp devices" path.
> 
> Does this patch fix it? And Corey - this is a good example of why the
> code shouldn't duplicate the "unregister stuff" in the module load
> error case vs the module exit path, and there should be a shared
> "cleanup()" function that is called by both. Can this be cleaned up,
> please?
> 
> PATCH IS UNTESTED!

That works.

Acked-and-tested-by: Randy Dunlap <randy.dunlap@oracle.com>

thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
