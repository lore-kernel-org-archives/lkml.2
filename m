Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1KWR6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:58:14 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56378 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab1KWR6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:58:12 -0500
MIME-Version: 1.0
In-Reply-To: <4ECCC6F3.8000403@suse.cz>
References: <20111123033850.GA11380@redhat.com>
	<CAFQmdRYTgQOb53kQOvk1jubZbvaOrfjVCq4aG1H0ceshw2vVPA@mail.gmail.com>
	<4ECCC6F3.8000403@suse.cz>
Date: Wed, 23 Nov 2011 09:58:11 -0800
Message-ID: <CAFQmdRbkYiOArK09smfMvf2DJ8h-bYvKyXRN_nmX-bPG8ENmjA@mail.gmail.com>
Subject: Re: tty related lockdep trace during bootup on 3.2-rc2
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 2:12 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> Oh, how it can be? You should vhangup the device on disconnect. Then you
> will be sure all close calls were performed before freeing the port.
> Then you can free the port, right?
>
> Like:
> * forbid further opens
> * tty_vhangup
> * stop the device
> * free the device state

Ok, interesting. It seems pretty different from what the driver is
currently doing. I'll see if I can figure out how to rework the
disconnect code.

I guess one remaining concern is that someone might still hold the
device open after hangup, so if we free the device state, which
includes the tty_port, something bad might happen, no?

> Also it looks like you have a leak in disconnect when there are users
> still. If I am looking correctly?

Funny you should say that. I'm also trying to investigate a case in
which the driver appears to leak tty devices, i.e. after a few days of
stress testing, /sys/class/tty is full of dangling ttyACMx symlinks
and new devices are ignored because acm_table is full.

Havard
