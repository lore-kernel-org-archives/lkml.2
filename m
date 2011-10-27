Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1J0RoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 13:44:21 -0400
Received: from mail-pz0-f56.google.com ([209.85.210.56]:51414 "EHLO
	mail-pz0-f56.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab1J0RoU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 13:44:20 -0400
X-Greylist: delayed 769 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Oct 2011 13:44:20 EDT
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Thu, 27 Oct 2011 10:31:30 -0700 (PDT)
In-Reply-To: <fa.sHib65lEoXP9G43lrndbDfam4CU@ifi.uio.no>
Reply-To: fa.linux.kernel@googlegroups.com
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=2620:0:1000:1b02:1aa9:5ff:fe24:3620;
 posting-account=B0m2yQoAAABHLnvb2W6ip1n_G1NPelzT
NNTP-Posting-Host: 2620:0:1000:1b02:1aa9:5ff:fe24:3620
References: <fa.DU5J+vcQ1k3A34VvvU/+Dois5+Y@ifi.uio.no> <fa.sHib65lEoXP9G43lrndbDfam4CU@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
MIME-Version: 1.0
Message-ID: <22032480.316.1319736691009.JavaMail.geo-discussion-forums@prgt10>
Subject: Re: [PATCH] exec: log when wait_for_dump_helpers aborts due to a signal
From: scott@netsplit.com
To: fa.linux.kernel@googlegroups.com
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, Earl Chew <earl_chew@agilent.com>,
        Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder whether we could use a slightly different approach for this loop.

In the current code in the case where there is a signal pending on the crashing process (in our case it looks like it's SIGTERM as a result of the process group being killed) we never call pipe_wait() at all. This means everything is certainly missing from /proc if the crashing process is reaped before crash-reporter gets a look-in.

What would be the side-effect of changing the code such that we call pipe_wait() at least once in this scenario, for example:


diff --git a/fs/exec.c b/fs/exec.c
index 25dcbe5..8959d304 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2030,11 +2030,11 @@ static void wait_for_dump_helpers(struct file *file)
        pipe->readers++;
        pipe->writers--;
 
-       while ((pipe->readers > 1) && (!signal_pending(current))) {
+       do {
                wake_up_interruptible_sync(&pipe->wait);
                kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
                pipe_wait(pipe);
-       }
+       } while ((pipe->readers > 1) && (!signal_pending(current)));
 
        pipe->readers--;
        pipe->writers++;

This way around would it not at least wait for the core_pattern user mode helper to call read() at least once before bailing out due to signal?

Scott
