Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2GEUMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:12:07 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:21283 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab2GEUMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:12:05 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2012 16:12:05 EDT
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=hnpKoNAfD3enxWE1cxpYxYD9V6pJzpH2ndgUf7AgUK3FxRWvSd6JoAUT6KHn
	/LSh/KxoNZLcb7KuvqAhXcq3gBoiGx/svi0d1SgsLzUnapGIACp40lxAE
	KxiKcIcXwnhEGpfWucnAnPaMOzdAltumw9p7tNKhICofKT/SMPhvuY=;
X-Spam-Processed: mail.digidescorp.com, Thu, 05 Jul 2012 15:03:47 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1533b6ee34=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341518624.2012.19.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted
 inodes/dentries
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 05 Jul 2012 15:03:44 -0500
In-Reply-To: <87a9zeeu4a.fsf@devron.myhome.or.jp>
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	 <1341342576-15394-3-git-send-email-steve@digidescorp.com>
	 <87pq8bokcp.fsf@devron.myhome.or.jp>
	 <WC20120704180312.82023C@digidescorp.com>
	 <87a9zeeu4a.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 12:59 +0900, OGAWA Hirofumi wrote: 
> "Steve Magnani" <steve@digidescorp.com> writes:
> > I may yet rip out the get_name code. The testing I did before posting the 
> > patch seemed to indicate that it was needed - I saw ESTALE errors without 
> > get_name support that I did not see with it present. But I've been 
> > digging into this some more and I think that was just a coincidence; 
> > probably I just generated more extreme memory pressure when testing 
> > without get_name. I should know more tomorrow.

The get_name code can go away.

It turns out that it is much harder to generate severe memory pressure
in my virtual 3.5 kernel than in my embedded 2.6.35 kernel.
fat_reconstitute_inode() was not being exercised in 3.5 as much as I
thought.

And, there was a change made in 3.5
(b0b0382bb4904965a9e9fca77ad87514dfda0d1c) that causes the parent
i_logstart field not to be populated when building NFS file handles for
shares marked 'no_subtree_check'. That causes fat_reconstitute_inode()
to fail, because it interprets the parent of such objects as 'root'
rather than as 'unknown'.

I'm reworking the patch to cope with the 'unknown' case, and to address
your other comments. Still need to look into lock_super() vs.
inode->i_mutex.

Steve
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>


