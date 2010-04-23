Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab0DWKzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:55:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40559 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752696Ab0DWKzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:55:52 -0400
Date: Fri, 23 Apr 2010 12:00:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Locking question for DRM
Message-ID: <20100423120054.0987f3e4@lxorguk.ukuu.org.uk>
In-Reply-To: <u2l21d7e9971004230344u491d3d6bqd093884ce8b21e7c@mail.gmail.com>
References: <20100423112222.67cfcbb2@lxorguk.ukuu.org.uk>
	<s2l21d7e9971004230324me3de75b0w58a9907999b7872a@mail.gmail.com>
	<20100423113717.1188415d@lxorguk.ukuu.org.uk>
	<u2l21d7e9971004230344u491d3d6bqd093884ce8b21e7c@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't think that works. drm_open_helper doesn't appear to be under the
> > BKL merely the struct mutex.
> 
> It blocks the case you specified of two releases happening together.

But not parallel open/release

> > But setmaster can sleep so the BKL is dropped on contention of the
> > struct_mutex, ditto dropmaster
> 
> they should only sleep in the mutex lock nuless the driver callback is
> allocating memory. but yeah its a bit of a mess.

With the mutex alone the damage is done. Consider two setmasters and some
other action which is making the mutex contend

		CPU1				CPU2

file->priv->minor->master == NULL ?
file_priv->minor->master != file_priv->master

mutex_lock	(drop BKL)
				file->priv->minor->master === NULL
				master != file_priv->master
				mutex_lock   [drop BKL]
takes mutex
minor->master = drm_master_get
is_master = 1
master_set
drop mutex
return 0
				takes mutex
				minor->master = drm_master_get
				is_master = 1
				master_set
				drops mutex
				return 0


Alan
