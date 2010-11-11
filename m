Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab0KKUA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:00:28 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40418 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab0KKUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:00:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=usD6ijgX548Eues1kvxD9mnpdxbugRRwa3UnWAcucLJ/VhkezKQS46neYw/4L4OX34
         l07EzEwsUtNpV2VHzeptMyGuGAedSxFGuX6QIAmtplRKpxc73g7tbchxzPSa5NFamSuP
         j738noMDk0IUA+oaJvn73lA2ylsQrwSAm5G4c=
Date: Thu, 11 Nov 2010 12:00:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Rafi Rubin <rafi@seas.upenn.edu>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chasedouglas@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        =?iso-8859-1?Q?St=E9phane?= Chatty <chatty@enac.fr>
Subject: Re: [PATCH] input: Introduce light-weight contact tracking
Message-ID: <20101111200014.GB14508@core.coreip.homeip.net>
References: <1289161108-32309-1-git-send-email-rydberg@euromail.se>
 <4CD724BC.8020702@seas.upenn.edu>
 <4CD80FCB.20903@euromail.se>
 <4CD82B28.4060706@seas.upenn.edu>
 <4CD84A81.3000208@euromail.se>
 <4CDB7C05.1090306@seas.upenn.edu>
 <4CDBCB0E.2020005@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDBCB0E.2020005@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 11:53:02AM +0100, Henrik Rydberg wrote:
> On 11/11/2010 06:15 AM, Rafi Rubin wrote:
> 
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> >> For every (number of used slots, number of current contacts) pair, two
> >> consecutive arrays of values are generated. The first contains the matrix
> >> indices corresponding to a certain mapping from contacts to slots. The second
> >> contains the actual slot assignment.
> >>
> >> To find the optimal matching, one simply scans through the appropriate index
> >> array, extracting the slot assignment corresponding to the minimum sum of matrix
> >> elements. This process is combinatorial and in general scales much worse than
> >> for instance the hungarian algorithm, but for small numbers, it can be
> >> implemented with very good speed.
> > 
> > It occurs to me that it might be a good idea to restate our goals and assumptions.
> 
> 
> The main goal of my patch is to device a simple, stable, parameter-free matching
> function that can be used in interrupt context. If you have such a function,
> about a hundred lines of code, completes in a couple of hundred cycles, tested
> and benchmarked in the mtdev framework, and which can do six fingers, I would be
> happy to use that instead. Otherwise, I suggest we focus on this patch.
> 
> > So that's why I selected the approach and data structures I used.  Now if you
> > can tell me the studio 17 is going to be the only device that will ever run
> > these routines that has more than 4 contacts and is not tracked, then sure,
> > screw it.  I have no reason to believe that is a good assumption.
> 
> 
> The N-trig device is the only device in the kernel that requires special ghost
> filtering. All other devices send reliable data, and either have fewer contacts,
> handle their own tracking, or send all data to userspace. Future devices will
> most likely have tracking capabilities, and even if they do not, protocol A and
> mtdev handles that case. Thus, the question is really whether a new device would
> produce unreliable contact data. I find that unlikely.
> 
> 
> > Even if we do want to limit the code to 4 contacts, we still need some motion
> > estimation, particularly for the lower frame rate devices.
> 
> 
> Second-order methods for a device that does not even produce zeroth-order
> contact data? As far as I know, the first-order tracking in mtdev has not
> disappointed anyone yet, so your statement seems to need elaboration.
> 

Guys, with the filters being purely in-kernel library-like solutions
(i.e they do not export any API/ABI visible to userspace I see no
problem with having several (well a couple, let's not get carried away)
filter algorithms available. Most of the drivers will probably use the
one that is limited to 4(?) fingers if it is indeed faster, and ones
that need to track more fingers and do not have help of the hardware
might employ the slower option. The only concern is that such drivers
might need to offload such tracking to a thread/workqueue.

-- 
Dmitry
