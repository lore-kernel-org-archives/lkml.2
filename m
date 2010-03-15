Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936772Ab0COWbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:31:35 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:47405 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149Ab0COWbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:31:33 -0400
Subject: Re: [PATCH] vfs: pass struct file to do_truncate on O_TRUNC opens
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-nfs@vger.kernel.org
In-Reply-To: <1268689152-19168-1-git-send-email-jlayton@redhat.com>
References: <1268689152-19168-1-git-send-email-jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 18:31:28 -0400
Message-ID: <1268692288.3040.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 8 sum msgs/h 2 total rcpts 2556 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: A7BF944B1BACFC0D24B1813D62043909F79A7D93
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 245 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 17:39 -0400, Jeff Layton wrote: 
> When a file is opened with O_TRUNC, the truncate processing is handled
> by handle_truncate(). This function however doesn't receive any info
> about the newly instantiated filp, and therefore can't pass that info
> along so that the setattr can use it.
> 
> This makes NFSv4 misbehave. The client does an open and gets a valid
> stateid, and then doesn't use that stateid on the subsequent truncate.
> It uses the zero-stateid instead. Most servers ignore this fact and
> just do the truncate anyway, but some don't like it (notably, RHEL4).
> 
> It seems more correct that since we have a fully instantiated file at
> the time that handle_truncate is called, that we pass that along so
> that the truncate operation can properly use it.

At least in the O_CREAT|O_TRUNC case, we really should modify
nfs4_opendata_alloc() to set the attrs.ia_size to zero, so that the
server does an atomic open(O_CREAT|O_TRUNC) for us (see the DESCRIPTION
paragraph in RFC3530 section 14.2.16). There shouldn't be any need for
an extra truncate RPC call.

Plain open(O_TRUNC) probably does need something along the lines of what
you propose, however.

Cheers
  Trond 

