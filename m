Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab0JPKeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 06:34:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56545 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0JPKeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 06:34:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UuviD5lA3mE2vZ1GY6VR46vocIf6fTvgF+doPeOnlIM7P4rO0Q2r7ss3LQGY8K2FqL
         pSpyw2jJm+fOAB/tiu4FF1+QTORiok0C146zGpy54XsFWb8DpeWitp3YKOQ6anka/4AM
         n1hJYE7QS1G3OkQR8Yqn3y9qmI0p8aqjsUbwY=
Subject: Re: [PATCH 03/19] fs: Convert nr_inodes and nr_unused to per-cpu
 counters
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101016100441.GP4681@dastard>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
	 <1287216853-17634-4-git-send-email-david@fromorbit.com>
	 <1287217776.2799.69.camel@edumazet-laptop>  <20101016100441.GP4681@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Oct 2010 12:27:32 +0200
Message-ID: <1287224852.2799.130.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 16 octobre 2010 à 21:04 +1100, Dave Chinner a écrit :

> get_nr_inodes_unused() is called on every single shrinker call. i.e.
> for every 128 inodes we attempt to reclaim. Given that I'm seeing
> inode reclaim rate in the order of a million per second on a 8p box,
> that meets your criteria for using the generic percpu counter
> infrastructure.
> 
> Also, get_nr_inodes() is also called by get_nr_dirty_inodes(), which is
> called by the high level inode writeback code, so will typically be
> called in the order of tens of times per second, and the number of
> calls increased depending on the number of filesystems that are
> active. It's still much higher frequency than your "cat
> /proc/sys/fs/inode-nr" example indicates it might be called.
> 
> So I'd say that by your reasoning, the choice of using the generic
> percpu counters is the right one to make.

You missed one thing :

In cases you mention, you want a precise count (aka
percpu_counter_sum_positive()), not the approximate one (aka
percpu_counter_read_positive()).

The only difference is then the possible/online cpu loop difference.

I am saying :

No need to maintain an approximate counter if we dont _read_ it, ever.

Andrew answer : Eric, cant you implement this generically ?



