Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2HVFi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:38:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44431 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab2HVFiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:38:54 -0400
Date: Wed, 22 Aug 2012 06:38:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] task_work: add a scheduling point in task_work_run()
Message-ID: <20120822053847.GM23464@ZenIV.linux.org.uk>
References: <1341193591.2249.3.camel@falcor>
 <20120702034310.GE22927@ZenIV.linux.org.uk>
 <20120702051155.GF22927@ZenIV.linux.org.uk>
 <1341229790.2350.1.camel@falcor>
 <20120702120259.GG22927@ZenIV.linux.org.uk>
 <1341234091.2166.5.camel@falcor>
 <20120702133329.GH22927@ZenIV.linux.org.uk>
 <1341240603.2086.1.camel@falcor>
 <1345554314.5158.490.camel@edumazet-glaptop>
 <50346DB9.7040303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50346DB9.7040303@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 01:27:21PM +0800, Michael Wang wrote:

> And can we make sure that it is safe to sleep(schedule) at this point?
> It may need some totally testing to cover all the situation...

task_work callback can bloody well block, so yes, it is safe.  Hell,
we are doing final close from that; that can lead to any amount of
IO, up to and including on-disk file freeing and, in case of vfsmount
kept alive by an opened file after we'd done umount -l, actual final
unmount of a filesystem.  That can more than just block, that can block
for a long time if that's a network filesystem...
