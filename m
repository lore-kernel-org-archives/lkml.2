Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab2DNMPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 08:15:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:59796 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab2DNMPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 08:15:32 -0400
Message-ID: <1334405716.2528.88.camel@twins>
Subject: Re: [Lsf] [RFC] writeback and cgroup
From: Peter Zijlstra <peterz@infradead.org>
To: Steve French <smfrench@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, ctalbott@google.com, rni@google.com,
        andrea@betterlinux.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, lsf@lists.linux-foundation.org,
        linux-mm@kvack.org, jmoyer@redhat.com, lizefan@huawei.com,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org
Date: Sat, 14 Apr 2012 14:15:16 +0200
In-Reply-To: <CAH2r5mvP56D0y4mk5wKrJcj+=OZ0e0Q5No_L+9a8a=GMcEhRew@mail.gmail.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
	 <20120404145134.GC12676@redhat.com>
	 <20120404184909.GB29686@dhcp-172-17-108-109.mtv.corp.google.com>
	 <CAH2r5mvP56D0y4mk5wKrJcj+=OZ0e0Q5No_L+9a8a=GMcEhRew@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 14:23 -0500, Steve French wrote:
> Current use of bdi is a little hard to understand since
> there are 25+ fields in the structure.  

Filesystems only need a small fraction of those.

In particular,

  backing_dev_info::name	-- string
  backing_dev_info::ra_pages	-- number of read-ahead-pages
  backing_dev_info::capability	-- see BDI_CAP_*
  
One should properly initialize/destroy the thing using:

  bdi_init()/bdi_destroy()


Furthermore, it has hooks into the regular page-writeback stuff:

  test_{set,clear}_page_writeback()/bdi_writeout_inc()
  set_page_dirty()/account_page_dirtied()
  
but also allows filesystems to do custom stuff, see FUSE for example.

The only other bit is the pressure valve, aka.
{set,clear}_bdi_congested(). Which really is rather broken and of
dubious value.


