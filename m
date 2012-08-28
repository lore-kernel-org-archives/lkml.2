Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2H1XBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 19:01:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48728 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2H1XBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 19:01:43 -0400
Date: Tue, 28 Aug 2012 16:01:08 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120828230108.GI1048@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <20120828204910.GG24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120828222800.GG1048@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828222800.GG1048@moria.home.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 03:28:00PM -0700, Kent Overstreet wrote:
> On Tue, Aug 28, 2012 at 01:49:10PM -0700, Tejun Heo wrote:
> > Overall, I *think* this is correct but need to think more about it to
> > be sure.
> 
> Please do. As much time as I've spent staring at this kind of stuff,
> I'm pretty sure I've got it correct but it still makes my head hurt to
> work out all the various possible deadlocks.

Hilarious thought: We're punting bios to a rescuer thread that's
specific to a certain bio_set, right? What if we happen to punt bios
from a different bio_set? And then the rescuer goes to resubmit those
bios, and in the process they happen to have dependencies on the
original bio_set...

I think it's actually necessary to filter out only bios from the current
bio_set to punt to the rescuer.

God I love the block layer sometimes.
