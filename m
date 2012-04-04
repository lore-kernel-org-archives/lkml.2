Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab2DDXfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:35:37 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:39639 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab2DDXff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:35:35 -0400
Message-ID: <4F7CDACC.60002@gmail.com>
Date: Wed, 04 Apr 2012 16:35:40 -0700
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Colin Walters <walters@verbum.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by>  <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com>  <4F7A3CC2.1040200@zytor.com> <4F7C777E.10608@gmail.com> <1333559412.10230.67.camel@lenny>
In-Reply-To: <1333559412.10230.67.camel@lenny>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/4/12 10:10 AM), Colin Walters wrote:
> On Wed, 2012-04-04 at 09:31 -0700, KOSAKI Motohiro wrote:
>
>> Ideally possible. but practically impossible. 2) people don't use a their
>> own malloc. they only uses open sources alternative malloc. And, I think
>> you have too narrowing concern. Even though malloc people adds a workaround,
>> the standard inhibit to use it
>
> What do you mean?  If as hpa says, the maintainer of e.g. google
> tcmalloc added a call to pthread_atfork(), then code which uses
> opendir() would start working.

 From point of application programmer view, they have no right to choose
malloc implementation. user can easily override it by using LD_PRELOAD.
So, even though one or two malloc implementation will be fixed, it doesn't
mean user land folks pain will gone. they are living more painful world.
At least, they told me so.

But, I discussed about this issue with hpa today and we agreed the best way is
to merge hpa fdwalk() into libc. It makes maximum happy, example, glib can drop
its own fdwalk implementation. so, I'd like to discuss libc folks.




>>   and people may continue to use more dangerous
>> RLIM_NOFILE loop. 1) I haven't seen _practical_ userland software uses such
>> linux internal hacking. Almost all major software can run on multiple OSs.
>
> Except that if you're using /proc/self/fd, you're already relying on
> Linux-specific functionality.  So it's not burdensome to use "struct
> linux_dirent" and O_DIRECTORY either.
>
> In GLib we're presently doing the regular /proc+opendir() under
> #ifdef __linux__:
> http://git.gnome.org/browse/glib/tree/glib/gspawn.c#n932
>
> Now I'd happily switch to hpa's fdwalk() implementation if I was aware
> of someone using glib in combination with an alternative malloc hitting
> this problem.
>
> Basically I think hpa is right here, and it's not really worth adding
> a new system call.
>
> The thing is, even if it were added today, since we need to run on old
> kernels, we'd have to carry the code to use the /proc trick
> approximately forever.  And in the end all nextfd() would accomplish
> would be a *third* case in the already messy ifdefs/fallbacks
> in the various implementations of process spawning.

Nope. some OSs only have a silly rlimit(RLIM_NOFILE), then userland continue
to keep rlimit(NOFILE) for fallback. it's no linux specific.

I mean, OpenJDK and glib already has a linux specific trick, but many software
don't.
