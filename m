Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab1FINQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:16:32 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42879 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480Ab1FINQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:16:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EWB30oy1Gmv9aaOAZ/0mmkwO6IMprVSit4ogRYenCLY9+69WJF17QUmqpx1ouzFGN1
         2yn7f8M+2Y4dskurPe181xv67Z9W+tZ6p+ZObMgUNDINRZE/e4bueO0WzzngJTW03gpt
         1kvoyOwH8L1S4lKhbDYSRUpYmuLhbhHFQoh+M=
MIME-Version: 1.0
In-Reply-To: <20110608151732.2b321b9a.akpm@linux-foundation.org>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
 <BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com> <m18vtkq57c.fsf@fess.ebiederm.org>
 <BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com> <20110602134338.0c56160e@lxorguk.ukuu.org.uk>
 <BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com> <m1hb88e3qs.fsf@fess.ebiederm.org>
 <BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com> <20110608151732.2b321b9a.akpm@linux-foundation.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 9 Jun 2011 15:16:14 +0200
Message-ID: <BANLkTinXwE0K5nJ649rhNxN06KvwLNDeCA@mail.gmail.com>
Subject: Re: [PATCH] sysctl: add support for poll()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>,
        neilb@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 00:17, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 2 Jun 2011 19:32:49 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> > Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>> Acked-By: Kay Sievers <kay.sievers@vrfy.org>
>
> The patch itself doesn't look too bad to me...
>
> We already have several pollable procfs files, such as
> fs/proc/base.c:mounts_poll() and I think drivers/md has one.  I do
> think that any work in this area should end up with those custom
> make-procfs-pollable hacks being identified and removed.

For these files we can probably move the event counter into the
seq_file structure, and get rid of the dance to kmalloc it and assign
it to seq_file->private. That might simplify the logic a bit.

[Adding Neil, to get his opinion of moving 'event' so seq_file and get
rid of the malloc dance]

The wait_queue and the change counter needs to be in the same context
as the watched data, so we can probably not really help with generic
proc infrastructure here.

This patch is sysctl infrastructure, which is kind of a subclass of
proc like seq_file is. I have no good idea how to share anything
between them. Unlike the three current users of seq_file, the sysctl
stuff already moved the needed things to the common sysctl code.

If moving the individual event counter to seq_file makes sense, we can
give it a shot, but it don't think it really affects the sysctl case.
Maybe someone has good idea how to unify them, I currently don't have.

Kay
