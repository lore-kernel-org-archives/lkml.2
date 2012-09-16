Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2IPUwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 16:52:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35436 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2IPUwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 16:52:20 -0400
MIME-Version: 1.0
In-Reply-To: <505626A8.8040806@mimc.co.uk>
References: <505626A8.8040806@mimc.co.uk>
Date: Sun, 16 Sep 2012 22:52:18 +0200
Message-ID: <CAFLxGvy_VMTMZxESgDoZrOaxm94q+BeSfEb+tXeWrUc5J0gHbw@mail.gmail.com>
Subject: Re: Advice on mmap() "feature"
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 9:21 PM, Mark Jackson <mpfj-list@mimc.co.uk> wrote:
> Apologies if this is the wrong place to post this query.  Please feel free
> to redirect me to the correct place.
>
> I have come across a weird (but documented [1]) "feature" of mmap(), which
> is:-
>
> "The mmap()function adds an extra reference to the file associated with the
> file descriptor fildeswhich is not removed by a subsequent close() on that
> file descriptor. This reference is removed when there are no more mappings
> to the file."
>
> In my embedded application, this is resulting in the consumption of
> available file descriptors.
>
> As an example I wrote the following test running on Ubuntu 11.04 64bit.
>
> #include <fcntl.h>
> #include <errno.h>
> #include <stdio.h>
> #include <sys/mman.h>
>
> #define FRAM_SIZE            (64 * 1024)
> #define FRAM_BASE_ADDRESS    0x00000000
>
> int main(int argc, char **argv)
> {
>     int i;
>     for (i = 0; i < 5000; i++)
>     {
>         // open the fram device
>         int m_fdFram = open("/dev/mem", O_RDWR | O_SYNC);
>         if (m_fdFram < 0)
>         {
>             printf("could not open /dev/mem, exiting with errno %d\n",
> errno);
>             return 0;
>         }
>
>         // map the device to memory
>         char *m_pFram = (char *)mmap(    0,
>                                         FRAM_SIZE * sizeof(unsigned short),
>                                         PROT_READ | PROT_WRITE,
>                                         MAP_SHARED,
>                                         m_fdFram,
>                                         FRAM_BASE_ADDRESS);
>         if ((int)m_pFram == -1)
>         {
>             close(m_fdFram);
>             m_fdFram = -1;
>             printf("could not mmap, exiting with errno %d\n", errno);
>             return 0;
>         }
>
>         // now remove the mapping
>         if (m_pFram)
>         munmap(m_pFram, FRAM_SIZE);

You unmap less memory than you map...

-- 
Thanks,
//richard
