Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006Ab2AABVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 20:21:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab2AABV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 20:21:29 -0500
Date: Sat, 31 Dec 2011 20:23:31 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: cifs: ls of mount point gives input/output error (probably
 related to CIFS: getdents() broken for large dirs)
Message-ID: <20111231202331.2a03bb35@corrin.poochiereds.net>
In-Reply-To: <4EFF110C.7010302@gmail.com>
References: <4EFBAF99.3010208@gmail.com>
	<20111228210420.2a422d11@corrin.poochiereds.net>
	<4EFC413A.80302@gmail.com>
	<20111229083930.77fafba8@tlielax.poochiereds.net>
	<4EFC7124.3060900@gmail.com>
	<4EFD7EBB.2060708@gmail.com>
	<20111230081120.3f7710f1@tlielax.poochiereds.net>
	<4EFDFC4E.30102@gmail.com>
	<20111231065922.05727805@tlielax.poochiereds.net>
	<4EFF04E3.70200@gmail.com>
	<4EFF110C.7010302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Dec 2011 15:41:32 +0200
Konstantinos Skarlatos <k.skarlatos@gmail.com> wrote:

> On 31/12/2011 2:49 μμ, Konstantinos Skarlatos wrote:
> > On Σάββατο, 31 Δεκέμβριος 2011 1:59:22 μμ, Jeff Layton wrote:
> >> On Fri, 30 Dec 2011 20:00:46 +0200
> >> Konstantinos Skarlatos<k.skarlatos@gmail.com> wrote:
> >>
> >>> On 30/12/2011 3:11 μμ, Jeff Layton wrote:
> >>>> On Fri, 30 Dec 2011 11:04:59 +0200
> >>>> Konstantinos Skarlatos<k.skarlatos@gmail.com> wrote:
> >>>>
> >>>>> On 29/12/2011 3:54 μμ, Konstantinos Skarlatos wrote:
> >>>>>> On Πέμπτη, 29 Δεκέμβριος 2011 3:39:30 μμ, Jeff Layton wrote:
> >>>>>>> On Thu, 29 Dec 2011 12:30:18 +0200
> >>>>>>> Konstantinos Skarlatos<k.skarlatos@gmail.com> wrote:
> >>>>>>>
> >>>>>>>> On 29/12/2011 4:04 πμ, Jeff Layton wrote:
> >>>>>>>>> On Thu, 29 Dec 2011 02:08:57 +0200
> >>>>>>>>> Konstantinos Skarlatos<k.skarlatos@gmail.com> wrote:
> >>>>>>>>>
> >>>>>>>>>> I mount via cifs a windows XP share, df gives me correct sizes,
> >>>>>>>>>> but when
> >>>>>>>>>> I ls the mount point i get input/output error.
> >>>>>>>>>> strace: http://pastebin.com/WXf8M1nu
> >>>>>>>>>>
> >>>>>>>>>> mount --verbose -t cifs -o
> >>>>>>>>>> username=administrator,password=blahblah
> >>>>>>>>>> //192.168.0.11/jobs /mnt/backups/montaz/jobs
> >>>>>>>>>> mount.cifs kernel mount options:
> >>>>>>>>>> ip=192.168.0.11,unc=\\192.168.0.11\jobs,,ver=1,user=administrator,pass=********
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> df
> >>>>>>>>>> //192.168.0.11/jobs 114464
> >>>>>>>>>> 105196 9268 92% /mnt/backups/montaz/jobs
> >>>>>>>>>>
> >>>>>>>>>> ls /mnt/backups/montaz/jobs/
> >>>>>>>>>> ls: reading directory /mnt/backups/montaz/jobs/: Input/output
> >>>>>>>>>> error
> >>>>>>>>>> total 0
> >>>>>>>>>>
> >>>>>>>>>> the fun thing is that i can cd to a lower level directory, and ls
> >>>>>>>>>> works
> >>>>>>>>>> fine there! only the mount point has the problem
> >>>>>>>>>>
> >>>>>>>>>> ls /mnt/backups/montaz/jobs/test
> >>>>>>>>>> total 44K
> >>>>>>>>>> drwxr-xr-x 1 root root 0 Apr 30 2010 blah blah/
> >>>>>>>>>> ......
> >>>>>>>>>>
> >>>>>>>>>> kernel version 3.2rc7
> >>>>>>>>>>
> >>>>>>>>>> this seems to be related to :
> >>>>>>>>>> https://lkml.org/lkml/2011/8/1/427
> >>>>>>>>>> Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for
> >>>>>>>>>> large dirs
> >>>>>>>>>>
> >>>>>>>>> Hmmm, maybe. What makes you think that it's related? What sort of
> >>>>>>>>> server are you seeing this against?
> >>>>>>>> Windows XP service pack 2 (greek)
> >>>>>>>
> >>>>>>> How many files are in the directory?
> >>>>>>>
> >>>>>> 140 folders and 20 files
> >>>>>>
> >>>>> Attached is a tcp dump of my session.
> >>>> I tried reproducing this here, but wasn't able to. Testing against my
> >>>> xp box worked fine.
> >>>>
> >>>> Most likely, the FIND_FILE responses are falling afoul of the code in
> >>>> coalesce_t2 or check2ndT2. Unfortunately that code is pretty
> >>>> complicated and I'm not certain what the problem actually is...
> >>>>
> >>>> One thing that's interesting is that the total data being sent in the
> >>>> request is rather large (16336 bytes). I think that's legit, but maybe
> >>>> it's exceeding the end of the buffer once we try to coalesce it.
> >>>>
> >>>> Would it be possible to get the cFYI output from this test?
> >>> I did not get a cFYI output from that test, but i redid a
> >>> mount-ls-umount and am attaching the tcpdump
> >>> Also here http://pastebin.com/J20uC6kU you can find the cifsFYI and the
> >>> contents of /proc/fs/cifs/DebugData form the same test
> >>>>
> >>>> Is this a regression? Did it work with earlier kernels and only
> >>>> recently start failing?
> >>>>
> >>> I do not know, and i am a bit afraid to downgrade this machine below 3.0
> >>> due to some changes arch linux has introduced recently. I can always set
> >>> up a few virtual machines though, and i can even request permission from
> >>> my company to give you shell access if you like. Which kernel versions
> >>> would you like me to test?
> >>
> >>
> >> Ok, that tells us a little:
> >>
> >> -------------------[snip]---------------------
> >> [96268.787078] fs/cifs/cifssmb.c: In FindFirst for
> >> [96268.787083] fs/cifs/transport.c: For smb_command 50
> >> [96268.787086] fs/cifs/transport.c: Sending smb: total_len 88
> >>
> >> ...FIND_FIRST command is sent
> >>
> >> [96268.787690] fs/cifs/connect.c: RFC1002 header 0x1104
> >> [96268.787697] fs/cifs/connect.c: missing 12048 bytes from transact2,
> >> check next response
> >> [96268.787865] fs/cifs/connect.c: RFC1002 header 0x1104
> >> [96268.787870] fs/cifs/connect.c: missing 12036 bytes from transact2,
> >> check next response
> >> [96268.788037] fs/cifs/connect.c: RFC1002 header 0x1104
> >> [96268.788042] fs/cifs/connect.c: missing 12036 bytes from transact2,
> >> check next response
> >> [96268.788371] fs/cifs/connect.c: RFC1002 header 0xdb0
> >> [96268.788375] fs/cifs/connect.c: missing 12888 bytes from transact2,
> >> check next response
> >>
> >> ...all four parts of the response are collected here
> >>
> >> [96268.788391] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50
> >> mid=12 state=16
> >>
> >> ...but the state at this point is MID_RESPONSE_MALFORMED
> >>
> >> [96268.788395] fs/cifs/cifssmb.c: Error in FindFirst = -5
> >> [96268.788397] fs/cifs/readdir.c: initiate cifs search rc -5
> >> [96268.788398] fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid
> >> = 737644) rc = -5
> >>
> >> ...which makes readdir return -EIO
> >>
> >> -------------------[snip]---------------------
> >>
> >> Based on that, it looks like something in one of these frames caused
> >> coalesce_t2() to return an error. I don't see the problem right offhand
> >> in the capture, but T2 response handling is pretty complex so it can be
> >> hard to see.
> >>
> >> Would it be possible for you to rebuild your kernel (or just cifs.ko)
> >> with this patch? Once you do that, rerun the test with cFYI turned up,
> >> and it should help point out what the problem is.
> >>
> >> Thanks,
> >
> > Ok i am now rebuilding the kernel and will report when i have results.
> http://pastebin.com/scgyDjhT and attached tcpdump

Very helpful -- I think I see the bug now. Can you test this patch and
let me know if it fixes the problem? You'll need to back out the debug
patch first, and then apply this one. If it works, I'll plan to clean
this up and send to Steve for inclusion.

Thanks...

----------------------[snip]---------------------

[PATCH] cifs: fix buffer length check and better instrumentation for coalesce_t2

Fix the buffer length check in coalesce_t2. The current one checks to
see that the rfc1002 length is not larger than the buffer that will
hold it. It gets the check wrong though. The buffer is MAX_CIFS_HDR_SIZE
larger than the current check allows for.

Also, to make it easier to debug problems of this sort, when coalesce_t2
returns an error, have it throw a cFYI message that explains the reason.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8cd4b52..0b033ff 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -243,16 +243,21 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 
 	remaining = total_data_size - total_in_buf;
 
-	if (remaining < 0)
+	if (remaining < 0) {
+		cFYI(1, "Server sent too much data. total_data_size=%hu "
+			"total_in_buf=%hu", total_data_size, total_in_buf);
 		return -EPROTO;
+	}
 
-	if (remaining == 0) /* nothing to do, ignore */
+	if (remaining == 0) {
+		/* nothing to do, ignore */
+		cFYI(1, "no more data remains");
 		return 0;
+	}
 
 	total_in_buf2 = get_unaligned_le16(&pSMB2->t2_rsp.DataCount);
-	if (remaining < total_in_buf2) {
+	if (remaining < total_in_buf2)
 		cFYI(1, "transact2 2nd response contains too much data");
-	}
 
 	/* find end of first SMB data area */
 	data_area_of_target = (char *)&pSMBt->hdr.Protocol +
@@ -267,23 +272,29 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 	/* copy second buffer into end of first buffer */
 	total_in_buf += total_in_buf2;
 	/* is the result too big for the field? */
-	if (total_in_buf > USHRT_MAX)
+	if (total_in_buf > USHRT_MAX) {
+		cFYI(1, "coalesced total_in_buf too large (%u)", total_in_buf);
 		return -EPROTO;
+	}
 	put_unaligned_le16(total_in_buf, &pSMBt->t2_rsp.DataCount);
 
 	/* fix up the BCC */
 	byte_count = get_bcc(pTargetSMB);
 	byte_count += total_in_buf2;
 	/* is the result too big for the field? */
-	if (byte_count > USHRT_MAX)
+	if (byte_count > USHRT_MAX) {
+		cFYI(1, "coalesced BCC too large (%u)", byte_count);
 		return -EPROTO;
+	}
 	put_bcc(byte_count, pTargetSMB);
 
 	byte_count = be32_to_cpu(pTargetSMB->smb_buf_length);
 	byte_count += total_in_buf2;
 	/* don't allow buffer to overflow */
-	if (byte_count > CIFSMaxBufSize)
+	if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
+		cFYI(1, "coalesced BCC exceeds buffer size (%u)", byte_count);
 		return -ENOBUFS;
+	}
 	pTargetSMB->smb_buf_length = cpu_to_be32(byte_count);
 
 	memcpy(data_area_of_target, data_area_of_buf2, total_in_buf2);
@@ -291,8 +302,10 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 	if (remaining == total_in_buf2) {
 		cFYI(1, "found the last secondary response");
 		return 0; /* we are done */
-	} else /* more responses to go */
+	} else {/* more responses to go */
+		cFYI(1, "waiting for more secondary responses");
 		return 1;
+	}
 }
 
 static void
-- 
1.7.7.4


