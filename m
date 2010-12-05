Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab0LEHYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 02:24:53 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65456 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab0LEHYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 02:24:52 -0500
MIME-Version: 1.0
In-Reply-To: <4CFB33DA.1070306@brouhaha.com>
References: <4CFB33DA.1070306@brouhaha.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sun, 5 Dec 2010 02:24:30 -0500
Message-ID: <AANLkTikPESSNMRQ+WbzpLoRyhhK1UQRvnB5ifpUp+cnk@mail.gmail.com>
Subject: Re: mmap to address zero with MAP_FIXED returns ENOPERM for non-root users?
To: Eric Smith <eric@brouhaha.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 5, 2010 at 01:40, Eric Smith <eric@brouhaha.com> wrote:
> I'm doing some work with binary translation of an executable from a non-x86
> microcontroller to run in an x86 process, and need to have part of the
> memory map match that of the microcontroller.  This includes having some
> memory at virtual address zero.  I know why this isn't usually a good idea,
> and why mmap() won't give that out without MAP_FIXED.

> However, when I try an anonymous mmap() to virtual address zero with
> MAP_FIXED, I get ENOPERM unless running as superuser.

Hi Eric!

This is a specific security feature designed to reduce the security
impact of a kernel NULL-pointer dereference.  Specifically, the most
obvious vulnerability occurs if kernel code accidentally calls a NULL
function pointer or calls a function pointer through a NULL structure
pointer, but there are other ways to exploit it.  The actual exploit
is to map a page with code at address zero and then trigger the kernel
NULL-pointer-dereference, resulting in privileged execution of your
unprivileged code.

There is a sysctl tunable "vm.mmap_min_addr" that you can change to
modify this behavior, and SELinux-enabled systems can loosen this
behavior a bit, but it's not normally something you want to give to
unprivileged processes.

Since you're performing binary translation of a microcontroller, it
may be better to perform some kind of minimal memory-map translation
as a part of that.  For example, you should be able to introduce an
addition into each memory dereference operation without too much
overhead (IE: treat all microcontroller addresses as relative to a
particular "memory base address").

The Debian wiki has a pretty decent page describing the security
feature in more detail:
  http://wiki.debian.org/mmap_min_addr

Cheers,
Kyle Moffett
