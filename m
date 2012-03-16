Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab2CPKBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:01:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:47908 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386Ab2CPKBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:01:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="78303681"
From: "Du, Alek" <alek.du@intel.com>
To: Jiri Slaby <jslaby@suse.cz>
CC: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: RE: [PATCH] tty: hold lock across tty buffer finding and buffer
 filling
Thread-Topic: [PATCH] tty: hold lock across tty buffer finding and buffer
 filling
Thread-Index: Ac0CUERRacLD33MLTtaeiAHOWyOq2AAADUEAABDKXdAAIKULgAAQyYZQ//99bYD//3mIQA==
Date: Fri, 16 Mar 2012 10:01:17 +0000
Message-ID: <09F19C497AD02E4EA4E14917772649B70FCD3D59@SHSMSX102.ccr.corp.intel.com>
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com>
 <20120315100812.6cda2ef9@pyramind.ukuu.org.uk>
 <09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com>
 <4F630B4D.3040508@suse.cz>
 <09F19C497AD02E4EA4E14917772649B70FCD3D3F@SHSMSX102.ccr.corp.intel.com>
 <4F630E6D.4000307@suse.cz>
In-Reply-To: <4F630E6D.4000307@suse.cz>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We prepared the buffer, and use it. And during this, we don't release the spinlock of buf.lock, how the flush could happen?

               A
spin_lock
prepare the buffer
user the buffer
spin unlock


              B
Spin_lock
Flush
Free the buffer
Put buf.tail = NULL
Spin unlock



Thanks,
Alek
-----Original Message-----
From: Jiri Slaby [mailto:jirislaby@gmail.com] On Behalf Of Jiri Slaby
Sent: Friday, March 16, 2012 5:57 PM
To: Du, Alek
Cc: Jiri Slaby; Alan Cox; Tu, Xiaobing; linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; Zhang, Yanmin; Zuo, Jiao
Subject: Re: [PATCH] tty: hold lock across tty buffer finding and buffer filling

On 03/16/2012 10:49 AM, Du, Alek wrote:
> The tty structure is protect and not null, the tty->buf.tail is null. 
> Many people think the tty reference count isn't protected and cause 
> this bug, it is not true. :-)

You protect the pointer, not what is inside that structure. If you increment a tty reference count, tty->buf.tail won't be NULL iff tty is not NULL. IOW, you have to use tty_port_tty_set/get all around.

> For the flush case, it need acquire the spinlock to free the buffer and put buf.tail to NULL. So this patch will help:
> 
> Here is the example place, you can see the __tty_buffer_flush is inside the spinlock.

I'm not talking about flush. I'm talking about prepare. It returns a pointer to a tty buffer which may be concurrently freed by flush.

     A                                   B
================================================
prepare(&chars);
                                        flush(); memcpy(chars, data_from_HW); <- chars is freed now flip();

thanks,
--
js
suse labs
