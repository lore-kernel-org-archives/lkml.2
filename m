Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0FYN1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:27:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab0FYN07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:26:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <22746.1277470713@redhat.com>
References: <22746.1277470713@redhat.com> <4C24A4A0.90408@suse.de> <1277220206-3559-1-git-send-email-sjayaraman@suse.de> <yes> <9720.1277312290@redhat.com>
Cc: dhowells@redhat.com, Suresh Jayaraman <sjayaraman@suse.de>,
       Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 05/10] cifs: define superblock-level cache index objects and register them
Date: Fri, 25 Jun 2010 14:26:52 +0100
Message-ID: <23204.1277472412@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > > validate the root directory of the share in some way?
> >
> > I don't know if there is a way to do this.
> 
> Is there an inode number or something?  Even the creation time might do.

Looking in cifspdu.h, there are a number of things that it might be possible
to use.

 (1) FILE_ALL_INFO: CreationTime, IndexNumber, IndexNumber1, FileName
     (assuming this isn't flattened to '\' or something for the root of a
     share.

 (2) FILE_UNIX_BASIC_INFO: DevMajor, DevMinor, UniqueId.

 (3) FILE_INFO_STANDARD: CreationDate, CreationTime.

 (4) FILE_INFO_BASIC: CreationTime.

 (5) FILE_DIRECTORY_INFO: FileIndex, CreationTime, FileName.

 (6) SEARCH_ID_FULL_DIR_INFO: FileIndex, CreationTime, UniqueId, FileName.

 (7) FILE_BOTH_DIRECTORY_INFO: FileIndex, CreationTime, ShortName, FileName.

 (8) OPEN_RSP_EXT: Fid, CreationTime, VolumeGUID, FileId.

You may have to choose different sets of things, depending on what the server
has on offer.  Also, don't forget, if you can't work out whether a share is
coherent or not from the above, you can always use LastWriteTime, ChangeTime
and EndOfFile and just discard the whole subtree if they differ.

David
