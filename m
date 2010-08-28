Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0H1NXf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 09:23:35 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:4849 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0H1NXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 09:23:33 -0400
Date: Sat, 28 Aug 2010 09:15:16 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Valerie Aurora <vaurora@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Karel Zak <kzak@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Sanity check mount flags passed to
	change_mnt_propagation()
Message-ID: <20100828131516.GA5053@hash.localnet>
References: <20100826200318.GA13636@shell> <20100827011436.GB3521@parisc-linux.org> <20100827174313.GA26872@shell> <AANLkTik-uXDtvA9G7sr1becN235PMzFWmuD5t9Xu4yZX@mail.gmail.com> <20100828105707.GD3521@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100828105707.GD3521@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 04:57:07AM -0600, Matthew Wilcox wrote:
> > Didn't read surrounding code, but is that supposed to be '||'?
> > 
> > Otherwise the case where only a single non-propagation flag is
> > set no longer returns 0...
> 
> Val's original code returned 0 as failure.  So a single non-propagation
> flag set shouldn't return 0.

Not to belabor the point -- but her original code did return zero in
that case (2nd assertion fails):

#include <linux/fs.h>
#include <stdio.h>
#include <assert.h>

#define hweight32 dumb_hweight32

int dumb_hweight32(int a)
{
	int i;
	int weight = 0;

	for (i=0; i < 32; i++)
		weight += !!(a & (1 << i));

	return weight;
}

static int flags_to_propagation_type(int flags) {
	int type = flags & ~MS_REC;

	/* Fail if any non-propagation flags are set */
 	if (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
		return 0;
	/* Only one propagation flag should be set */
	if (((type & (MS_SHARED)) && (type & ~MS_SHARED)) ||
	   ((type & (MS_PRIVATE)) && (type & ~MS_PRIVATE)) ||
	   ((type & (MS_SLAVE)) && (type & ~MS_SLAVE)) ||
	   ((type & (MS_UNBINDABLE)) && (type & ~MS_UNBINDABLE)))
	       return 0;
	return type;
}

static int flags_to_propagation_type_2(int flags) {
 	int type = flags & ~MS_REC;

	/* Only one propagation flag should be set, and no others */
	if (hweight32(type) != 1 &&
	    (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE)))
		return 0;

	return type;
}

int main(int argc, char *argv[])
{
	int mytype = MS_RDONLY;

	assert(flags_to_propagation_type(mytype) == 0);
	assert(flags_to_propagation_type_2(mytype) == 0);
}

-- 
Bob Copeland %% www.bobcopeland.com

