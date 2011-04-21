Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1DUCp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:45:59 -0400
Received: from smtp.wow.synacor.com ([64.8.70.55]:56418 "EHLO
	smtp.mail.wowway.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1DUCp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:45:58 -0400
X-Spam-Rating: None
X_CMAE_Category: 0,0 Undefined,Undefined
X-CNFS-Analysis: v=1.1 cv=eKQ+N4rqOQiji9ijAFGVZbvuh9RsgY7ivWxzmg3MFRI= c=1 sm=0 a=EnAg6b0JcI4A:10 a=FKkrIqjQGGEA:10 a=M1VNycxITrcA:10 a=AhRLOILGsKkA:10 a=IkcTkHD0fZMA:10 a=VnNF1IyMAAAA:8 a=QP5IY3kgAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=AFMLxQ6ZnGbrZpqgB0sA:9 a=49PgCL5fJObShabSzq8A:7 a=QEXdDO2ut3YA:10 a=zEoJXyrrGmEA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=NqP0OC6my3GWRimS:21 a=AyY6HkRrYkjFnh0v:21 a=QLvOlBIuGJjmAZ5IHHaCwQ==:117
X-CM-Score: 0
Date: Wed, 20 Apr 2011 22:45:53 -0400 (EDT)
From: Stephen Powell <zlinuxman@wowway.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, 622570@bugs.debian.org
Message-ID: <2008017174.74978.1303353953675.JavaMail.root@md01.wow.synacor.com>
In-Reply-To: <20110419063400.GA2878@osiris.boeblingen.de.ibm.com>
Subject: Re: [OOPS s390] Unable to handle kernel pointer dereference at
 virtual kernel address (null)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [75.118.95.22]
X-Mailer: Zimbra 6.0.5_GA_2328.RHEL5_64 (zclient/6.0.5_GA_2328.RHEL5_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 02:34:01 -0400 (EDT), Heiko Carstens wrote:
> Stephen Powell wrote:
>> I installed linux-image-2.6.38-2-s390x version 2.6.38-3 on my up-to-date Wheezy
>> system today.  It runs in a virtual machine under z/VM 5.4.0 running in an LPAR
>> on an IBM z/890.  It IPLed just fine.  After the IPL, the system fell idle for a while.
>> Then a CRON job kicked off, which caused a page fault, which caused a kernel oops.
>> Here is the log:
>> ...
> 
> Ok, I was able to reproduce it and could verify that my patch fixes the bug.
> Thanks for reporting! The patch below will go upstream:

Great!  That's confirming evidence!  Thanks Heiko, Jonathan, Jan, and all others
who contributed.

> 
> Subject: [S390] pfault: fix token handling
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> f6649a7e "[S390] cleanup lowcore access from external interrupts" changed
> handling of external interrupts. Instead of letting the external interrupt
> handlers accessing the per cpu lowcore the entry code of the kernel reads
> already all fields that are necessary and passes them to the handlers.
> The pfault interrupt handler was incorrectly converted.  It tries to
> dereference a value which used to be a pointer to a lowcore field.  After
> the conversion however it is not anymore the pointer to the field but its
> content.  So instead of a dereference only a cast is needed to get the
> task pointer that caused the pfault.
> 
> Fixes a NULL pointer dereference and a subsequent kernel crash:
> 
> Unable to handle kernel pointer dereference at virtual kernel address (null)
> Oops: 0004 [#1] SMP
> Modules linked in: nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc
>                    loop qeth_l3 qeth vmur ccwgroup ext3 jbd mbcache dm_mod
>                    dasd_eckd_mod dasd_diag_mod dasd_mod
> CPU: 0 Not tainted 2.6.38-2-s390x #1
> Process cron (pid: 1106, task: 000000001f962f78, ksp: 000000001fa0f9d0)
> Krnl PSW : 0404200180000000 000000000002c03e (pfault_interrupt+0xa2/0x138)
>            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
> Krnl GPRS: 0000000000000000 0000000000000001 0000000000000000 0000000000000001
>            000000001f962f78 0000000000518968 0000000090000002 000000001ff03280
>            0000000000000000 000000000064f000 000000001f962f78 0000000000002603
>            0000000006002603 0000000000000000 000000001ff7fe68 000000001ff7fe48
> Krnl Code: 000000000002c036: 5820d010            l       %r2,16(%r13)
>            000000000002c03a: 1832                lr      %r3,%r2
>            000000000002c03c: 1a31                ar      %r3,%r1
>           >000000000002c03e: ba23d010            cs      %r2,%r3,16(%r13)
>            000000000002c042: a744fffc            brc     4,2c03a
>            000000000002c046: a7290002            lghi    %r2,2
>            000000000002c04a: e320d0000024        stg     %r2,0(%r13)
>            000000000002c050: 07f0                bcr     15,%r0
> Call Trace:
>  ([<000000001f962f78>] 0x1f962f78)
>   [<000000000001acda>] do_extint+0xf6/0x138
>   [<000000000039b6ca>] ext_no_vtime+0x30/0x34
>   [<000000007d706e04>] 0x7d706e04
> Last Breaking-Event-Address:
>   [<0000000000000000>] 0x0
> 
> For stable maintainers:
> the first kernel which contains this bug is 2.6.37.
> 
> Reported-by: Stephen Powell <zlinuxman@wowway.com>
> Cc: Jonathan Nieder <jrnieder@gmail.com>
> Cc: stable@kernel.org
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> 
>  arch/s390/mm/fault.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 9217e33..4cf85fe 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -558,9 +558,9 @@ static void pfault_interrupt(unsigned int ext_int_code,
>  	 * Get the token (= address of the task structure of the affected task).
>  	 */
>  #ifdef CONFIG_64BIT
> -	tsk = *(struct task_struct **) param64;
> +	tsk = (struct task_struct *) param64;
>  #else
> -	tsk = *(struct task_struct **) param32;
> +	tsk = (struct task_struct *) param32;
>  #endif
>  
>  	if (subcode & 0x0080) {

-- 
  .''`.     Stephen Powell    
 : :'  :
 `. `'`
   `-
