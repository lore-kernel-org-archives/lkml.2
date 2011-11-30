Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab1K3NeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:34:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab1K3NeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:34:05 -0500
Date: Wed, 30 Nov 2011 13:33:32 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Jan Kara <jack@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>
Cc: esandeen@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
Message-ID: <20111130133332.GV7595@agk-dp.fab.redhat.com>
Mail-Followup-To: Jan Kara <jack@suse.cz>,
	Mikulas Patocka <mpatocka@redhat.com>, esandeen@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	Valerie Aurora <val@vaaconsulting.com>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com> <20111128150400.GE6366@quack.suse.cz> <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com> <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com> <20111129101901.GA5635@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129101901.GA5635@quack.suse.cz>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 11:19:01AM +0100, Jan Kara wrote:
> On Mon 28-11-11 18:32:18, Mikulas Patocka wrote:
> > - skipping sync on frozen filesystem violates sync semantics. 
> > Applications, such as databases, assume that when sync finishes, data were 
> > written to stable storage. If we skip sync when the filesystem is frozen, 
> > we can cause data corruption in these applications (if the system crashes 
> > after we skipped a sync).

>   Here I don't agree. Filesystem must guarantee there are no dirty data on
> a frozen filesystem. Ext4 and XFS do this, ext3 would need proper
> page_mkwrite() implementation for this but that's the problem of ext3, not
> freezing code in general. If there are no dirty data, sync code (and also
> flusher thread) is free to return without doing anything.
 
Consider, during a 'create a snapshot' operation:
   I/O flow:  application -> filesystem -> LV -> disk

dm lockfs is issued by LVM.
  When this returns, the filesystem should be locked i.e. not issue any
  further I/O to the LV.  (But if it did happen to issue I/O, it
  wouldn't be a problem, as it would just get queued by dm and have no
  impact on the snapshot creation operation.)

The application is still running and might still be issuing writes to
the filesystem and might itself issue 'sync'.  But a 'sync' would only
be meaningful for already-completed writes and the lockfs process should
have already seen that they have hit disk.  So a sync issued while a
device is locked can always be skipped.  Have I missed something in this
reasoning, Mikulas?

Alasdair
