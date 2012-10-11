Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2JKMeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:34:12 -0400
Received: from mail.avalus.com ([89.16.176.221]:41980 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab2JKMeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:34:08 -0400
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2012 08:34:08 EDT
From: Alex Bligh <alex@alex.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Local DoS through write heavy I/O on CFQ & Deadline
Date: Thu, 11 Oct 2012 13:23:32 +0100
Message-Id: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
Cc: Alex Bligh <alex@alex.org.uk>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have noticed significant I/O scheduling issues on both the CFQ and the
deadline scheduler where a non-root user can starve any other process of
any I/O for minutes at a time. The problem is more serious using CFQ but is
still an effective local DoS vector using Deadline.

A simple way to generate the problem is:

  dd if=/dev/zero of=- bs=1M count=50000 | dd if=- of=myfile bs=1M count=50000

(note use of 2 dd's is to avoid alleged optimisation of the writing dd
from /dev/zero). zcat-ing a large file with stout redirected to a file
produces a similar error. Using ionice to set idle priority makes no
difference.

To instrument the problem we produced a python script which does a MySQL
select and update every 10 seconds, and time the execution of the update.
This is normally milliseconds, but under user generated load conditions, we
can take this to indefinite (on CFQ) and over a minute (on deadline).
Postgres is affected in a similar manner (i.e. it is not MySQL specific).
Simultaneously we have captured the output of 'vmstat 1 2' and
/proc/meminfo, with appropriate timestamps.

We have reproduced this on multiple hardware environments, using 3.2
(/proc/version_signature gives "Ubuntu 3.2.0-29.46-generic 3.2.24").
Anecdotally we believe the situation has worsened since 3.0.

We believe the problem is that dirty pages writeout is starving the system
of any other I/O, and whilst the process concerned should be penalised to
allow other processes I/O time, this is not happening.

Full info, including logs and scripts can be found at:
  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1064521

I believe this represents a local DoS vector as an unprivileged user can
effectively stall any root owned process that is performing I/O.

-- 
Alex Bligh




