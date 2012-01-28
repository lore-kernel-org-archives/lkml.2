Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab2A1Gzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 01:55:33 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:55672 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab2A1Gzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 01:55:33 -0500
Message-ID: <4F239BE1.4090106@msgid.tls.msk.ru>
Date: Sat, 28 Jan 2012 10:55:29 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110805 Icedove/5.0
MIME-Version: 1.0
To: Professor Berkley Shands <berkley@seas.wustl.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.0.18 tcsetattr on fd 0 when detached freezes system (RCU timeouts)
 (Centos 6.1 x86_64)
References: <4F234498.5070800@seas.wustl.edu>
In-Reply-To: <4F234498.5070800@seas.wustl.edu>
X-Enigmail-Version: 1.2.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.01.2012 04:43, Professor Berkley Shands wrote:
> 
> typedef struct
> {
>    struct termios term;
> } XKEY_DATA;
> 
> typedef XKEY_DATA *xkeyhandle;
> 
> static inline xkeyhandle xkeystart()
> {
> 
>    // Turn off echo.
>    struct termios temp;
>    err = tcgetattr(0, &temp);
>    if (err)
>    {
>       perror("tcgetattr failure");
>    }
> 
>    XKEY_DATA *handle = new XKEY_DATA;
>    handle->term = temp;
> 
>    temp.c_lflag &= ~ECHO;
>    temp.c_lflag &= ~ICANON;
> 
>    err = tcsetattr(0, TCSANOW, &temp);        // this line causes the kernel to get very sick
>    if (err)
>    {
>       perror("tcsetattr failure");
>    }
> 
>    return handle;
> 
> }
> 
> The above code, called from main() will produce an error from tcsh:
> 
> /home/bshands> ./a.out > /dev/null &
> [1] 3635
> /home/bshands>
> /home/bshands>
> [1]  + Suspended (tty output) ./a.out > /dev/null
> /home/bshands>
> 
> this does not appear on the redhat kernel, nor 2.6.32.43, but appeared infrequently in 3.0.9.
> in 3.0.18, doing this in the background does *EVIL* things.
> 
> ssh system "./a.out > /dev/null &" &
> 
> Now when the code reaches the tcsetattr() the system quits scheduling tasks.
> top shows 100%sy on 4/12 cores, kernel threads blocked, stalled tasks count increasing.

I used the following code:

=======================================
#include <termios.h>
#include <stdio.h>

int main() {
   struct termios temp;

   if (tcgetattr(0, &temp) != 0)
      perror("tcgetattr failure");

   temp.c_lflag &= ~ECHO;
   temp.c_lflag &= ~ICANON;

   if (tcsetattr(0, TCSANOW, &temp) != 0) // this line causes the kernel to get very sick
      perror("tcsetattr failure");

   return 0;
}
=======================================


But can't reproduce what you're observing.  It prints

 tcgetattr failure: Inappropriate ioctl for device
 tcsetattr failure: Inappropriate ioctl for device

and does not do any evil things.  I tried it on 3.0.18
on x86 on 32bits and 64bits.

What I'm doing wrong?

Thanks,

/mjt
