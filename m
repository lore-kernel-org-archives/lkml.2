Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab0EOS62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 14:58:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:47484 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab0EOS60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 14:58:26 -0400
Message-ID: <4BEEEEBA.9050506@kernel.org>
Date: Sat, 15 May 2010 20:58:02 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net
Subject: Re: [PATCH 3/8] block,ide: simplify bdops->set_capacity() to ->unlock_native_capacity()
References: <1273946974-29131-1-git-send-email-tj@kernel.org> <1273946974-29131-4-git-send-email-tj@kernel.org> <201005152048.00259.bzolnier@gmail.com>
In-Reply-To: <201005152048.00259.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 15 May 2010 18:58:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bartlomiej.

On 05/15/2010 08:48 PM, Bartlomiej Zolnierkiewicz wrote:
> This seems to rely on an optimistic assumption that command execution
> will always be successful and that no errors on disk or host level can
> ever happen..
>
> [ The assumption in question was introduced in the previous patch:
...
> originally if the command execution failed the 'capacity' would be 0 ]

Hmm... nothing really changes by this tho.  Whether unlocking succeeds
or not, the block layer will revalidate the disk and the state at that
point will be taken as the configuration to use.  There really is
nothing much else to do.  You try unlocking, if it unlocks, use new
capacity.  If unlocking fails, revalidation will report the limited
size and block layer will have to use that.  If the device dies due to
the unlocking attempt, well, the device is dead all the same.

> It also seems that the original code could be improved a lot to handle
> (very unlikely but not impossible) error situations better..

If retry is deemed necessary, it's best handled inside the per-driver
unlock handler.  I don't think pushing EH logic upto block layer in
this case would be a good idea.  Block layer is basically telling the
driver "do whatever you can do to unlock the native capacity, when
you're done, I'll restart from the beginning".

Thanks.

-- 
tejun
