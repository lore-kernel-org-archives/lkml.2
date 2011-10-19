Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab1JSSlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:41:35 -0400
Received: from mail.vyatta.com ([76.74.103.46]:50806 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab1JSSld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:41:33 -0400
Date: Wed, 19 Oct 2011 11:41:29 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net -v2] [BUGFIX] bonding: use flush_delayed_work_sync
 in bond_close
Message-ID: <20111019114129.162d895a@nehalam.linuxnetplumber.net>
In-Reply-To: <27007.1319047262@death>
References: <20111019081757.12455.24788.stgit@ltc219.sdl.hitachi.co.jp>
	<27007.1319047262@death>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011 11:01:02 -0700
Jay Vosburgh <fubar@us.ibm.com> wrote:

> Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com> wrote:
> 
> >The bond_close() calls cancel_delayed_work() to cancel delayed works.
> >It, however, cannot cancel works that were already queued in workqueue.
> >The bond_open() initializes work->data, and proccess_one_work() refers
> >get_work_cwq(work)->wq->flags. The get_work_cwq() returns NULL when
> >work->data has been initialized. Thus, a panic occurs.
> >
> >This patch uses flush_delayed_work_sync() instead of cancel_delayed_work()
> >in bond_close(). It cancels delayed timer and waits for work to finish
> >execution. So, it can avoid the null pointer dereference due to the
> >parallel executions of proccess_one_work() and initializing proccess
> >of bond_open().
> 
> 	I'm setting up to test this.  I have a dim recollection that we
> tried this some years ago, and there was a different deadlock that
> manifested through the flush path.  Perhaps changes since then have
> removed that problem.
> 
> 	-J

Won't this deadlock on RTNL.  The problem is that:

   CPU0                            CPU1
  rtnl_lock
      bond_close
                                 delayed_work
                                   mii_work
                                     read_lock(bond->lock);
                                     read_unlock(bond->lock);
                                     rtnl_lock... waiting for CPU0
      flush_delayed_work_sync
          waiting for delayed_work to finish...
              
                                    
