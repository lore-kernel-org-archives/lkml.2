Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1GMWU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:20:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64665 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab1GMWU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:20:26 -0400
From: Naohiro Aota <naota@elisp.net>
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hfsplus: Add record offset check
References: <1310529537.96670.YahooMailClassic@web29502.mail.ird.yahoo.com>
Date: Thu, 14 Jul 2011 07:20:04 +0900
In-Reply-To: <1310529537.96670.YahooMailClassic@web29502.mail.ird.yahoo.com>
	(Hin-Tak Leung's message of "Wed, 13 Jul 2011 04:58:57 +0100 (BST)")
Message-ID: <87k4blyga3.fsf@elisp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hin-Tak Leung <hintak_leung@yahoo.co.uk> writes:

> --- On Mon, 11/7/11, Naohiro Aota <naota@elisp.net> wrote:
>
>> Recently I have general protection
>> fault when I'm using hfsplus. This
>> fault seems to be caused by "record offset" which is larger
>> than "node
>> size".
>
> You have supposedly worked on this full time for 6 weeks under the
> google summer of code scheme... I am concerned that you have so far
> worked in isolation and not discuss your work with others, also you
> only mentioned a problem (the one on discussion here) only when I
> asked for a progress/status update.

Actually, it's not so relevant to the project. I don't use any tools I
developed on my hfsplus file systems.

> So please
> (1) explain the context of this problem - e.g. how did you corrupt the
> disk?

No. "Corrupted disk may .." is just a possibility problem. It doesn't
mean that I have corrupted the disk. I've just used the file systems
read only.

Also as Pekka noticed, "'recoff' is read from disk which can be easily
fuzzed to have an offset that's larger than node_size". This 'recoff' is
used as offset to memcpy without checking. This patch has the same
concept as commit 9250f925972d03ccc0c0a4dd4e9b794d2ef6d52b.

> (2) explain your reasoning of *how* and *why* you choose to band-aid
> over this problem - considered that you have not yet found the cause,
> you want to band-aid over it; there are multiple ways of band-aiding
> over it, why did you choose this specific approach? and you need to
> include a discussion of possible bad-side effects, if any, of
> band-aiding over such a problem.

hfsplus_bnode_read() which is called from hfsplus_bnode_read_u16(), is
causing the fault. Since hfs_bnode_read_u16() can return any u16
numbers, we cannot assume some value as "error code", so it is difficult
to check the error in hfsplus_bnode_read*(). Actually there is no way to
report the range error to the callers. If we'd like to check the range
and offset in hfsplus_bnode_read(), we need to modify not only
hfsplus_bnode_read() but also all the function callers. Would it be a
better solution? I don't think so.

Even if there is another root cause of this fault here I have, it's
still a big problem. Because 'recoff' is come from disk, it is easily
fuzzed to have invalid out of range value, and it cause the fault, and
make the file system completely unavailable untill the next reboot.

About bad-side effects: I don't think there is serious bad-side
effects. Above this patch code, 'recoff' is checked and if it is 0 and
below this patch code, 'retval' (= keylen) is checked to be in
acceptable range. In both case, hfsplus_brec_keylen() return 0. My patch
is just doing additional check. The caller of hfsplus_brec_keylen()
should be able to handle this 0 value as error code. If there is some
bad-side effect, the caller may also fail to handle 'recoff' == 0 case
or too large 'retval' (keylen) case. That should be another bug.

> (3) explain your purpose of posting this patch to linux-kernel. You
> just posted it, saying there is a problem, there is a band-aid. In
> what way do you expect others to respond to your posting? As it is a
> band-aid, request for inclusion to standard kernel release is out,
> really.

Purpose of this patch is as same as commit
9250f925972d03ccc0c0a4dd4e9b794d2ef6d52b. This is a patch to handle
on-disk corruption without oopsing.
