Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab0GVJ0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 05:26:04 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:46868 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab0GVJ0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 05:26:00 -0400
Date: Thu, 22 Jul 2010 11:25:57 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Sachin Sant <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [-next July 21] s390 build failure : kernel/workqueue.o
Message-ID: <20100722112557.14b65077@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <4C4718D5.1080902@kernel.org>
References: <4C46CEA3.7040503@in.ibm.com>
	<4C4718D5.1080902@kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 17:57:09 +0200
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 07/21/2010 12:40 PM, Sachin Sant wrote:
> > Today's next fails to build on a s390 box with
> > 
> >  CC      kernel/workqueue.o
> > kernel/workqueue.c: In function 'init_workqueues':
> > kernel/workqueue.c:3525: error: negative width in bit-field '<anonymous>'
> > make[1]: *** [kernel/workqueue.o] Error 1
> > 
> > Yesterday's next was good.
> > The following patches added/changed the BUILD_BUG_ON() statement.
> > 
> > bdbc5dd7de5d07d6c9d3536e598956165a031d4c
> >        workqueue: prepare for WQ_UNBOUND implementation
> > 7a22ad757ec75186ad43a5b4670fa7423ee8f480
> >         workqueue: carry cpu number in work data once execution starts
> > 
> > I have gcc version 4.3.2 installed on the system.
> 
> Hmmm... that's surprising.  Can you please attach the .config?

The BUILD_BUG_ON line gets expanded to:

((void)(sizeof(struct { int:-!!(WORK_CPU_LAST << WORK_STRUCT_FLAG_BITS >= 0x0UL); })));

WORK_CPU_LAST is:

enum {
 ..
 WORK_CPU_NONE = 32 + 1,
 WORK_CPU_LAST = WORK_CPU_NONE,
 ..
};

WORK_STRUCT_FLAG_BITS is:

 WORK_STRUCT_COLOR_SHIFT = 2,
 WORK_STRUCT_COLOR_BITS = 4,
 WORK_STRUCT_FLAG_BITS = WORK_STRUCT_COLOR_SHIFT +
      WORK_STRUCT_COLOR_BITS,

which boils it down to

((void)(sizeof(struct { int:-!!(33 << 6 >= 0x0UL); })));

gcc doesn't like this construct.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

