Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0KLKO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:14:29 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54944 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab0KLKO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:14:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a/P2UwNE37+UEZt8MnzfIYCn+WIbfOXUHLtj5XljeUEi1ElSWA6YPVFp8gdjnOnFtj
         BEZ3cmzStZql1jcVafJ3AhK2QtG6K6HmDk+jgJSipszpIHpbsQTAgdhFcubSl2y7zlwL
         YQysTfI7kZi8iCpj4u50U7QRpODqryng7ys1M=
MIME-Version: 1.0
In-Reply-To: <1289492965.12418.262.camel@gandalf.stny.rr.com>
References: <1289492965.12418.262.camel@gandalf.stny.rr.com>
Date: Fri, 12 Nov 2010 11:14:26 +0100
Message-ID: <AANLkTikz7nxaE=Xs=JUwoM0sXNnDcNrpsrTTBzJkysAD@mail.gmail.com>
Subject: Re: [PATCH] staging: ft1000: Copy from user into correct data
From: Belisko Marek <marek.belisko@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Thu, Nov 11, 2010 at 5:29 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> While doing a ktest.pl I used a MIN_CONFIG that had STAGING enabled, and
> a randconfig with CONFIG_DEBUG_STRICT_USER_COPY_CHECKS enabled caught
> the following bug:
>
> In file included from /home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/include/asm/uaccess.h:571:0,
>                 from /home/rostedt/work/autotest/nobackup/linux-test.git/include/linux/poll.h:14,
>                 from /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c:32:
> In function 'copy_from_user',
>    inlined from 'ft1000_ChIoctl' at /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c:702:36:
> /home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/include/asm/uaccess_32.h:212:26: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct
>
>
> Looking at the code it was obvious what the problem was. The pointer
> dpram_data was being allocated but the address was being written to.
> Looking at the comment above the code shows that it use to write into an
> element of that pointer where the '&' is appropriate. But now that it
> writes to the pointer itself, we need to remove the '&' otherwise we
> write over the pointer and not into the data it points to.
Good catch but anyway this interface is removed. Already send patches to Greg-KH
but there was some patch problem so they're not applied to next yet.
Thanks for effort.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
> index 87a6487..8e8197d 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
> @@ -699,7 +699,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
>                        break;
>
>                 //if ( copy_from_user(&(dpram_command.dpram_blk), (PIOCTL_DPRAM_BLK)Argument, msgsz+2) ) {
> -                if ( copy_from_user(&dpram_data, argp, msgsz+2) ) {
> +                if ( copy_from_user(dpram_data, argp, msgsz+2) ) {
>                     DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
>                     result = -EFAULT;
>                 }
>
>
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
