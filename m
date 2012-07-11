Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab2GKJXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:23:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59509 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2GKJXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:23:52 -0400
MIME-Version: 1.0
Date: Wed, 11 Jul 2012 18:23:49 +0900
Message-ID: <CAKYAXd_H9X8Grv9ekH0GP818_+sXqDr+MH5v87ddG28jmj9i1A@mail.gmail.com>
Subject: [RFC] Writeback : Partially set to interval of writeback per device
From: Namjae Jeon <linkinjeon@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        minchan@kernel.org, Wu Fengguang <fengguang.wu@intel.com>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, dchinner@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Mel Gorman <mgorman@suse.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Wanpeng Li <liwp.linux@gmail.com>, namhyung@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RFC] Writeback : Partially set to interval of writeback per device

At present Writeback threads are controlled by forker thread.
There is one FORKER (bdi-default) thread – which is responsible for
creating new flusher thread for the device and waking up the flusher
threads.

Now – FORKER thread and flusher (Writeback) threads – are both
checking the timing interval value from ‘dirty_writeback_interval’
So – if we have a case of reducing writeback interval – every
WRITEBACK I/O will be controlled using the same settings.

USE CASE:
We have a NFS setup -> with an Ethernet line of 100Mbps – while the
USB disk we have connected on the server has a local speed of 25MBps.

Now – if we perform write operation over NFS (from client to server).
First bottleneck is the network – as the data can travel at the
maximum speed of 100Mbps. But, when we check the default write speed
over NFS on USB HDD - it is around 8MB/sec i.e., atleast we expected
it to be near the NETWORK speed.

This was due to the NFS logic:
During Write operation – Initially pages are dirtied on the NFS client
side. After reaching the dirty limit/writeback limit (or in case of
sync)-> data is sent from the NFS client to the NFS server (so again
pages are dirtied at the NFS server). This is all done inside the
COMMIT call from NFS client to NFS server – which is synchronous.

i.e.,  if suppose 100MB of data is dirtied and sent from the client to
server inside a COMMIT call – then it will take minimum 100MB/100Mbps
~ 8-9seconds.

After 100MB data is reached locally -> it will take 100MB/25Mb/sec ~ 4sec
So – a total 12-13sec in all this operation – We makes it to be around
7~8MB/sec.
After all this data is written on the NFS server device- > COMMIT
response is sent to NFS client.

Now – we figured out that we can improve upon this WRITE performance –
by making use of ideal time at the NFS server i.e., while the data is
getting received from the NFS client-> initiate the WRITEBACK at the
NFS server.  Instead of writing after receiving complete data -> we
can write in parallel while the data is received. As Network is busy
in receiving data while the flusher thread is ideal during that time.
This will reduce the overall timings in COMMIT.

As part this we reduced the ‘dirty_writeback_interval’ -> we could see
the jump in performance to 10~11MB/sec.

Now – the problem is if we change ‘dirty_writeback_interval’ it would
impact the entire storage devices connected to the system. While only
one device which is being used for NFS purpose. So – main purpose is
to have WRITEBACK interval to be effective per device.

There could be many scenarios like this – which requires the Writeback
interval to be effective per device.

Let me know the opinion and advice about this approach.

Thanks.
