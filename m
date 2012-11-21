Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2KUAR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:17:59 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38522 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2KUAR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:17:58 -0500
MIME-Version: 1.0
In-Reply-To: <20121121000510.7a3c6673@pyramind.ukuu.org.uk>
References: <20121120215059.GA1859@www.outflux.net>
	<20121121000510.7a3c6673@pyramind.ukuu.org.uk>
Date: Tue, 20 Nov 2012 16:17:57 -0800
X-Google-Sender-Auth: bVqgYHoKzMcPtzi9RjYCjnrmcOI
Message-ID: <CAGXu5jJLRyQCj3dHeuQwvTnn2=qsJ4MsiiQRsuPLzLSzM2SUmA@mail.gmail.com>
Subject: Re: [PATCH v3] devtmpfs: mount with noexec and nosuid
From: Kees Cook <keescook@chromium.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ellyjones@chromium.org, Kay Sievers <kay@vrfy.org>,
        Roland Eggner <edvx1@systemanalysen.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 4:05 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> +config DEVTMPFS_SAFE
>> +     bool "Use nosuid,noexec mount options on devtmpfs"
>> +     depends on DEVTMPFS
>> +     help
>> +       This instructs the kernel to include the MS_NOEXEC and
>> +       MS_NOSUID mount flags when mounting devtmpfs. This prevents
>> +       certain kinds of code-execution attacks on embedded platforms.
>
> This description appears to be wrong as well as the code being pointless.
> It doesn't prevent any meaningful code execution attacks and the config
> entry might give people the delusion its useful or a security feature.

I'm not trying to say it's a magic cure-all. This feature is just for
trying to build a system that follows security best-practices: nothing
should be writable and executable, and that includes mount points.
Since the devtmpfs is mounted by the kernel, that's the logical place
to fix it. All the other mounts are triggered by userspace and pass
flags, so that's where those get fixed.

> Please provide a valid and meaningful example.

I don't need a specific example to follow best practices. Any example
I try to invent will appear far-fetched, but those are exactly the
kind of things that happen. Chaining a series of far-fetched
vulnerabilities is a reality, and trying to defend against those
things via simple best practices can be effective.

If you want an invented example, how about a uid-0 service (let's say
listening on dbus) that takes arguments for some command (say "df")
and let's say it's really badly written, and filters all shell metas
except ";" so it'll run "df -- $arg" where $arg can't contain any $IFS
characters, but can lead with a semi-colon, meaning it can run a
single command but can't control arguments. Let's say there's nothing
else on the system that just running it will cause a problem, and so a
second flaw in some other service (or maybe the same one) can write
files to arbitrary locations, and the only writable and executable
location in the filesystem tree is /dev (e.g. all other locations are
either read-only or noexec). So an attacker writes a file to /dev/evil
and then uses the other flaw to run it.

-Kees

-- 
Kees Cook
Chrome OS Security
