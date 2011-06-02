Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1FBRdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 13:33:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36506 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab1FBRdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 13:33:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cuaYHju81ZrS8PnIIWfUV9Crff+zrqLJpZvXtwYHT5XMkfs4vAO3UF60/sY++lLZih
         580ZwTMNcbyK/UD+z5nRTixvyqh3IGCyGjsXGT7xx9VkA30BfI5gXS5Kw6dkTLYOVB/G
         iKGctPvRVeyUyVmdrtGj8CMaZ2jZRYTIWkJCA=
MIME-Version: 1.0
In-Reply-To: <m1hb88e3qs.fsf@fess.ebiederm.org>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
 <BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com> <m18vtkq57c.fsf@fess.ebiederm.org>
 <BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com> <20110602134338.0c56160e@lxorguk.ukuu.org.uk>
 <BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com> <m1hb88e3qs.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 2 Jun 2011 19:32:49 +0200
Message-ID: <BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com>
Subject: Re: [PATCH] sysctl: add support for poll()
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 15:56, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:

>> With this patch in, if anyone wants to manage a file under /proc/sys
>> there's really a small amount of code to write. He only has to define
>> the new poll struct for that file.
>
> The support currently appears cumbersome to add, and it adds what appear
> to be unnecessary wake ups (say when the hostname in another uts
> namespace changes).

Yeah, *possibly* waking up once a day compared to *unconditionally*
waking up every second in every namespace and check if something has
changed. If that *possibly* should be optimized, which I think isn't
necessary at all, I guess the logic could be moved down to the
namespaced data.

> There is no explanation at all of why you care about the nis domainname.

Just the same reason as the hostname, we need to know when the
kernel's internal state changes. regardless who did it and why, system
services need to follow it.

> Since there does not appear to be a specific problem that this problem
> is being aimed at, since the code just looks like extra maintenance and
> since the code needed to support this appears to be unnecessarily
> cumbersome I am going to nack the patch for now.
>
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Please provide solid technical reasons, why we can't to the same we do
everywhere else since years, or provide working alternatives. Until
then:

Acked-By: Kay Sievers <kay.sievers@vrfy.org>

> If the goal here is just to fix the general case then we probably
> want to get inotify going on proc files instead of poll.  Either
> that or we want pollable files to appear as something besides files
> so that it is clear to their users that poll will work.

I think poll() is the natural interface if you care about the data in
a file. It's the same an single fd you care, and not some iniotify
watch, fd, pathname to register, and filter for whatever comes out
there.

We already use exactly the same semantics for quite some years for
/proc/mounts, /proc/swaps, /proc/mdstat, ... and all over /sys. The
patch just provides the missing pieces that /proc provides, but
/proc/sys is missing.

I don't disagree, it might be nice to have generic inotify support on
/proc for this or other problems. But unless you want to work on it
now, and it would solve these problems, I don't see how we can get the
functionality we need, and that seems to solved with this patch.
Besides the fact that I think poll() is the simple and better
solution.

Thanks,
Kay
