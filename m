Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab2GQONl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:13:41 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44649 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab2GQONk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:13:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120717135201.GF1638@fysh.org>
References: <CAFDTedp84TuxHpz2SJTG_jdjtkQ7r9qkCjqQWT5Zg22LrT7tTg@mail.gmail.com>
 <20120717135201.GF1638@fysh.org>
From: =?ISO-8859-1?B?QWRyaeFu?= <adrianbn@gmail.com>
Date: Tue, 17 Jul 2012 15:13:18 +0100
Message-ID: <CAFDTedowCyNgBtiPQUPVUv1XocMEhQJfyawjYxEkaXFX5E8H1A@mail.gmail.com>
Subject: Re: Setreuid distinction about (uid_t)-1
To: =?ISO-8859-1?B?QWRyaeFu?= <adrianbn@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 2:52 PM, Athanasius <link@miggy.org> wrote:
> On Tue, Jul 17, 2012 at 10:27:55AM +0100, Adrián wrote:
>>         uid = atoi(argv[1]);
>>         printf("%u\n",uid);
>>         if (setreuid(uid,uid)==-1){
>>                 printf("Setreuid to %u failed\n ",uid);
>>                 perror("E");
>>                 exit(1);
>>         }
>>         execve("/bin/sh",args,NULL);
>>
>> I've been calling this binary with a bunch of different uid numbers,
>> and I came across this weird behaviour with the (uid_t) -1 value:
>
>   From the man page:
>
>        Supplying a value of -1 for either the real or effective user ID forces
>        the system to leave that ID unchanged.
>
>> adrian@home-pc:~$ /tmp/suid-tests
>> Usage: /tmp/suid-tests target_uid
>> adrian@home-pc:~$ /tmp/suid-tests 0
>> 0
>> Setreuid to 0 failed
>> E: Operation not permitted
>> adrian@home-pc:~$ /tmp/suid-tests -1
>> 4294967295
>
>   So this succeeded, by actually doing nothing.
>
>> $ id
>> uid=1000(adrian) gid=1000(adrian)
>> groups=1000(adrian),4(adm),20(dialout),24(cdrom),46(plugdev),109(lpadmin),110(sambashare),111(admin)
>> adrian@home-pc:~$ /tmp/suid-tests -2
>> 4294967294
>> Setreuid to 4294967294 failed
>> E: Operation not permitted
>> adrian@home-pc:~$ /tmp/suid-tests -3
>> 4294967293
>> Setreuid to 4294967293 failed
>> E: Operation not permitted
>>
>> If the binary is setuid, the -1 call effectively rises the euid to
>> root (0), although other arbitrary values are properly being set:
>
>   Because, again, -1 asks to leave things as is.  And as you've made
> the binary setuid and owned by root when you run it euid is set to 0, and
> the -1 leaves it alone.
>
>> adrian@home-pc:~$ ls -hl /tmp/suid-tests
>> -rwsr-x--- 1 root adrian 8,5K 2012-07-17 10:53 /tmp/suid-tests
>> adrian@home-pc:~$ /tmp/suid-tests -1
>> 4294967295
>> # id
>> uid=1000(adrian) gid=1000(adrian) euid=0(root)
>> groups=0(root),4(adm),20(dialout),24(cdrom),46(plugdev),109(lpadmin),110(sambashare),111(admin),1000(adrian)
>
>   Yup, totally as expected.
>
>> adrian@home-pc:~$ /tmp/suid-tests -2
>> 4294967294
>> $ id
>> uid=4294967294 gid=1000(adrian)
>> groups=4(adm),20(dialout),24(cdrom),46(plugdev),109(lpadmin),110(sambashare),111(admin),1000(adrian)
>
>   -2 isn't a magic value, but as you're euid == 0 the kernel will do
> what you asked and set uid to '-2', with some signed/unsigned conversion
> going on you get 4294967294.
>
> --
> - Athanasius = Athanasius(at)miggy.org / http://www.miggy.org/
>                   Finger athan(at)fysh.org for PGP key
>            "And it's me who is my enemy. Me who beats me up.
> Me who makes the monsters. Me who strips my confidence." Paula Cole - ME
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAlAFbgAACgkQSEDmQuIYzh2dSACfT+xjClQw/I68T7PnaF1W32B6
> kNcAmQHtVTb0S+oc2TIwy0uVZAO6K2Vc
> =7GG0
> -----END PGP SIGNATURE-----
>

Thanks a lot Athanasius. What I still can't see is why is the -1
exception there, as I assume that if you want to leave one of the ids
unchaged you can call:

setreuid(0,geteuid());

If you want to leave euid unchanged, right? Is there a need or reason
to be doing this differentiation in the setreuid code?

Thanks again,
Adrián
