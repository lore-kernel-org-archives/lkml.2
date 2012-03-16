Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032782Ab2CPNut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:50:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:36087 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030389Ab2CPNur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:50:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119784925"
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
Thread-Index: Ac0CUERRacLD33MLTtaeiAHOWyOq2AAADUEAABDKXdAAIKULgAAQyYZQ//99bYD//3mIQIAAiHuA//95JNCAAIvVgP//ZyLgABannID//12AYA==
Date: Fri, 16 Mar 2012 13:50:44 +0000
Message-ID: <09F19C497AD02E4EA4E14917772649B70FCD3E02@SHSMSX102.ccr.corp.intel.com>
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com>
 <20120315100812.6cda2ef9@pyramind.ukuu.org.uk>
 <09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com>
 <4F630B4D.3040508@suse.cz>
 <09F19C497AD02E4EA4E14917772649B70FCD3D3F@SHSMSX102.ccr.corp.intel.com>
 <4F630E6D.4000307@suse.cz>
 <09F19C497AD02E4EA4E14917772649B70FCD3D59@SHSMSX102.ccr.corp.intel.com>
 <4F63101D.70507@suse.cz>
 <09F19C497AD02E4EA4E14917772649B70FCD3D6B@SHSMSX102.ccr.corp.intel.com>
 <4F631449.7090302@suse.cz>
 <09F19C497AD02E4EA4E14917772649B70FCD3DCC@SHSMSX102.ccr.corp.intel.com>
 <4F632C15.5070902@suse.cz>
In-Reply-To: <4F632C15.5070902@suse.cz>
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

For #1, as I said, we already held the tty refcount. The tty refcount cannot help this crash.

For #2, this patch will avoid memcpy to a NULL pointer and avoid a kernel crash.

Thanks,
Alek
-----Original Message-----
From: Jiri Slaby [mailto:jirislaby@gmail.com] On Behalf Of Jiri Slaby
Sent: Friday, March 16, 2012 8:04 PM
To: Du, Alek
Cc: Jiri Slaby; Alan Cox; Tu, Xiaobing; linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; Zhang, Yanmin; Zuo, Jiao
Subject: Re: [PATCH] tty: hold lock across tty buffer finding and buffer filling

On 03/16/2012 12:33 PM, Du, Alek wrote:
> Isn't this the nature of "flush" ? If the driver is trying to insert 
> chars to tty buffer, while the app is going to flush the buffer, or shutdown the port, that's quite nature that those data gone. Why should I care ?
> 
> Sorry, you missed the point of this patch.

No, you do not follow what I am writing.

1) Your driver is broken.
2) Your patch does not solve the problem universally.

ad 1) Use tty refcounting and you won't need to care about buf.tail being NULL due to shutdown. As an added value, you will fix the other races too.

ad 2) With your patch, drivers which use tty_prepare_flip_string are given a tty buffer (chars parameter) which may be *freed* (not flushed,
_freed_) at any time by ioctl flush after the function returns. I.e. the relocking is hopeless in that case. It only helps drivers which use tty_insert_flip_string*.

I don't know right now what could be a real cure for point 2). Maybe RCU. Maybe leaving the lock locked in tty_prepare_flip_string and introducing tty_finish_flip_string containing an unlock. To be called right after memcpy_fromio or alike in the drivers.

Or maybe even removing that interface completely...

thanks,
--
js
suse labs
