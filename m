Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2DBNzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 09:55:01 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40348 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab2DBNzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 09:55:00 -0400
Date: Mon, 2 Apr 2012 16:54:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: question about blkio_get_stat()
Message-ID: <20120402135455.GA15588@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F79AFB0.00BA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Divyesh,

Smatch complains that we go outside the array in blkio_get_stat().

block/blk-cgroup.c
   731          if (type == BLKIO_STAT_DEQUEUE)
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^
BLKIO_STAT_DEQUEUE is 9.

   732                  return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
   733                                          blkg->stats.dequeue, cb, dev);
   734  #endif
   735  
   736          for (sub_type = BLKIO_STAT_READ; sub_type < BLKIO_STAT_TOTAL;
   737                          sub_type++) {
   738                  blkio_get_key_name(sub_type, dev, key_str, MAX_KEY_LEN, false);
   739                  cb->fill(cb, key_str, blkg->stats.stat_arr[type][sub_type]);
                                                    ^^^^^^^^^^^^^^^^^^^^
This array only has 4 elements and if "type" is 9 we're past the end of
array.

   740          }

It's odd that Smatch only started complaining about this now, but this
code has been there for years.  I'm puzzled by what changed.  Sorry if
there is something obvious I have missed.

regards,
dan carpenter
