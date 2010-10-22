Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab0JVQGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:06:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42888 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab0JVQGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=irXrJcJCI4x0XBi89Y7w8lGL22OAsIOAhtd1wtAAMfJJQwBj7to+hRCdNE3lIQYux1
         ui/4cqIB7p5a6Mi01JDOkc1+GwklYwb4EaWAKaXzF2rY/NwkLUjrJfmyEdUNM3AmYEQz
         GdBG6k3JRNnB/oBMm/qAmYQxlbRjMHmYI7upk=
MIME-Version: 1.0
In-Reply-To: <4CC16B1E.4060709@suse.de>
References: <20101022013544.0fdab0e0@werewolf.home>
	<4CC16B1E.4060709@suse.de>
Date: Fri, 22 Oct 2010 11:06:31 -0500
Message-ID: <AANLkTikooXeGZPMTRXT=T+Fve3z-8Cy9RzxMqDxQRoOd@mail.gmail.com>
Subject: Re: CIFS is slooow, gvfs is fast
From: Steve French <smfrench@gmail.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: jamagallon@ono.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 5:44 AM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
>
> (Cc linux-cifs@vger.kernel.org)
>
> On 10/22/2010 05:05 AM, J.A. Magallón wrote:
> > Problem: speed is _VERY_ different.
> > R/W through the automount point (CIFS fs), is roughly 7-8 MB/s (ridiculous
> > for gigabit speeds).
> > R/W through Gnome/gvfs (kind of fuse) goes around 35 - 40 MB/s (400 Mbits/s),
> > that look much better.
>
> What is the kernel version In which you are seeing the problem? I'm not
> seeing this on 2.6.36-rc4. Do you have a wired interface as well? Are
> you sure that both are using the same network path?
>
> > I have tried with different rsize/wsize in mount, but speed is the same
> > (perhaps I did not get the right values...).
>

Read sizes for cifs are relatively small at 16K (unless you change the
maximum buffer sizes at insmod time), and cifs write size is 56K.
This relatively smaller read size and the serializing of relatively
small reads in cifs_readpages can cause slower speeds than you might
expect reading files over gigabit if only one process is using the
network especially if long network latency (lots of dead time on the
network leading to low network utilizations).   cifs will perform
relatively well compared to other options as the number of processes
accessing the network increases, because a lot of work has gone into
locking.  dbench results will often show 50 simultaneous requests to
each Samba server (50 is the traditional maximum number of
simultaneous requests that smb/cifs servers support).   For workloads
other than sequential read workloads - cifs does relatively better as
well.

In the future with smb2 the maximum number of requests can vary, and
the maximum read size is larger which helps, as does the parallelized
smb2 write code which Pavel wrote over the summer for Google Summer of
Code.

--
Thanks,

Steve
