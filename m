Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab1EKT2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:28:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45136 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1EKT2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FFjQcFTzoaUrW5yNmHsDAbPn4cLLtOuoewCqW42KAKgGRdsinmHLzdK74RGYnEBwKj
         OePwj0zLFugPXgPxNRBEyCGZnQeRgDakMrKOcoFxrrh2rsJLjZQEIN2oxGjklTjL/rSf
         xbSyzmMzi4o5oJaf639Q6CqHeN6wD+5AGq66I=
MIME-Version: 1.0
In-Reply-To: <30230.1305133219@redhat.com>
References: <30230.1305133219@redhat.com>
Date: Wed, 11 May 2011 12:28:49 -0700
Message-ID: <BANLkTinr18+f12kyMZdiYAu+hNqH+5XyXQ@mail.gmail.com>
Subject: Re: Unionmount fallthru directory entries
From: Valerie Aurora <valerie.aurora@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:00 AM, David Howells <dhowells@redhat.com> wrote:
>
> What are unionmount fallthru directory entries for and why are they needed?

The long version of this answer is in:

http://lwn.net/Articles/325369/

The short version is that fallthrus allow you to generate and use a
32-bit d_off in readdir() using the topmost file system's native
readdir() implementation.  It lets you process duplicates and
whiteouts only once per directory, instead of every time you open it,
and does not require pinning O(size of all unioned dirs) memory while
the directory is open, and does not require a d_off generating hack
when readdir() runs off the end of the first dir (which no one has
made fs-agnostic so far).  The problems with previous approaches are
summarized in that article.

> I'm guess that what they do is indicate that the dirent in question must be
> looked up in the corresponding directory on the underlying fs.

Yes, if you are doing something that isn't just readdir().

> As to why they are needed, am I right in thinking that unionmount caches a
> copy of all the lower directory's entries in the upper directory with fallthru
> markers set on the first call to readdir?

Yes, but actually on the first lookup, not first readdir(), if I
recall correctly.  The duplicate and whiteout processing are done
exactly once, on first lookup of the directory, and then the directory
is marked opaque.

It's the best solution I've seen so far, but that doesn't mean it
can't be improved.

-VAL
