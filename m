Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1IPO0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:26:54 -0400
Received: from mail.anarazel.de ([217.115.131.40]:37834 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1IPO0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:26:53 -0400
From: Andres Freund <andres@anarazel.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Improve lseek scalability v3
Date: Fri, 16 Sep 2011 16:26:49 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <20110916130054.GA8997@parisc-linux.org>
In-Reply-To: <20110916130054.GA8997@parisc-linux.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109161626.50000.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 Sep 2011 15:00:55 Matthew Wilcox wrote:
> On Thu, Sep 15, 2011 at 04:06:46PM -0700, Andi Kleen wrote:
> > Currently generic_file_llseek users synchronize all on the inode i_mutex,
> > which is very heavy handed because it affects even different processes.
> > 
> > This patchkit attempts to make generic_file_llseek (mostly) lockless.
> 
> Yes, but, are there any real workloads which care?  I know will-it-scale
> says that lseek doesn't scale, but any real app which has a seek-heavy
> workload is surely using pread()/pwrite() by now ... after all, they
> were in UNIX98 so they've been a standard for 13 years.
Postgres uses llseek() to check wether the filesize has changed, 
pread()/pwrite() won't help with that.
An unlocked llseek will likely be faster than fstat(). Especially if the 
latter invokes some LSM module which lseek doesn't do.

Now postgres certainly could start synchronizing the filesize in shared memory 
between processes, but ...

Andres
