Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1AJSVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:21:18 -0500
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:25786 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752952Ab1AJSVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:21:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=tlFglijPDbMPmi0FtXtttDLIuenPjS7FM1suo/YN6v5r7dgjRLP898qNbunKg/Lg4Mv8FAZ8HEVYcQ+HNHAc5sMLNZYSWDqFMC2B2Nc888w24o6xASCu+4Abi0MG6g3haOlTb1HitLyW2bA6zfuttaRIkuGZJsQ0i7wVbxIIcjQ=;
Message-ID: <537305.92125.qm@web31812.mail.mud.yahoo.com>
X-YMail-OSG: FDG.GjwVM1l2kVlH8r6L4KEQMBXjt1p.8BZwTevMzjfbPK7
 .VApEbh9e2SQAuwXEanXFNOl5fWua8kVR0wRk32B7OWdzovCu6u5rBybIsct
 hzYv.DpxJprnowE1D6kaSzGod5EBwIWFv8HbeyzC7JSPALdGmq4lhFr5Y7LX
 HwPamy.sESDyQtMQkLF_LWwX8tPn_vwsarauEWQwlUGOilYCkLEc.lnltuY4
 LDlLTXxMWYBjP.Hvk8asiDQAKhyY8nMQwePtKKapLaahP82DWl5qbN__DpAp
 vGIvSFXyomJyYcuDDjUdUbBhmVAWt8ZCBsUg5kVimolO4cIrvc2l_p_idm1k
 k._lKRC2dHnH8RGKpIAeKWWAURjQrCQE0ebdmGQq.mSw_YCLXB5Vkb28iU5R
 hf2hS3gIcgM0-
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.108.291010
Date: Mon, 10 Jan 2011 10:21:16 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: SCSI reusing tags during error recovery
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Observed is on the wire, the following scenario:

0: Tag A (READ) -->
  (Times out)
1: Tag X (TMF ABORT TASK, TTBM=A) -->
2: Tag X (TMR FUNCTION COMPLETE) <--
3: Tag A (TUR) -->
4: Tag A (TUR status GOOD) <--
5: Tag A+2 (some command) -->
...

Undoubtedly resulting from the SCSI layer reusing the request
structure of the timed out Tag A to issue the Test Unit Ready
command, sequence 3.

However, if the task manager were unable to abort Tag A and
returned a different task management result, then the TUR would
complete with CHECK CONDITION (ABORTED COMMAND, OVERLAPPED
COMMANDS ATTEMPTED). Not all transports require the task router
to implement overlapped tag checking, and in most it is optional.
The TUR should go out with Tag A+1.

The SCSI layer should ideally, not perform error recovery ("error
handling" to use Linux' own terminology) on behalf of a timed out
request, but allow higher layers to issue TMF only based on a
ITLQ (tag, a number) or ITL (LUN, a structure) or IT nexus
(target port).

A previous issue I raised, tag generation for tags of task
management functions, can be found here:
http://marc.info/?l=linux-scsi&m=128902337522890&w=2

   Luben

