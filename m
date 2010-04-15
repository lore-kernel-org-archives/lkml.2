Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab0DPAZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 20:25:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403Ab0DPAZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 20:25:31 -0400
Date: Thu, 15 Apr 2010 17:22:05 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath9k@venema.h4ckr.net,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: Lockup inside of stop_machine() during modprobe aes (was Re:
 Another AR5008 hang)
Message-Id: <20100415172205.c1e57636.akpm@linux-foundation.org>
In-Reply-To: <4bbb7896.48c3f10a.30b9.365b@mx.google.com>
References: <4bb0e2da.04c2f10a.32b2.11ae@mx.google.com>
	<1269928986.3927.5.camel@jlt3.sipsolutions.net>
	<4bb1f940.47c2f10a.3469.609b@mx.google.com>
	<4bb235fb.0baa660a.5b56.ffffa9c2@mx.google.com>
	<4bbb7896.48c3f10a.30b9.365b@mx.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Apr 2010 11:08:22 -0700 (PDT) Ben Gamari <bgamari.foss@gmail.com> wrote:

> 
> ...
>
> I just built 2.6.34-rc3 with the appropriate fixes for the ACPI thermal lockdep
> issues and have attached the dmesg output of the crash below. It appears that
> modprobe is freezing with a few locks held while inserting aes.ko. In
> particular, it seems that the kernel is deadlocking inside of stop_machine()
> while flushing workqueues.
> 
> ...
>

My guess would be that ieee80211 is calling crypto->request_module()
under rtnl_lock, and the fact that rtnl_lock is held is causing
modprobe->stop_machine to not complete.

> P.S. I am now quite certain that I was mistaken in saying that 2.6.33 was
> affected. This seems to just be a 2.6.34 issue.

OK, thanks, I'll ask Rafael and Maciej to track this as a post-2.6.33
regression, probably wireless.

