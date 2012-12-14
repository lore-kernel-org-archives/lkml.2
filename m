Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab2LNVVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:21:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237Ab2LNVVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:21:37 -0500
From: Paul Moore <pmoore@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mprivozn@redhat.com, wkevils@gmail.com
Subject: Re: [PATCH] tuntap: fix ambigious multiqueue API
Date: Fri, 14 Dec 2012 16:21:33 -0500
Message-ID: <1537306.clOAp6XvaO@sifl>
Organization: Red Hat
User-Agent: KMail/4.9.4 (Linux/3.6.6-gentoo; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1355478810-10144-1-git-send-email-jasowang@redhat.com>
References: <1355478810-10144-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 14, 2012 05:53:30 PM Jason Wang wrote:
> The current multiqueue API is ambigious which may confuse both user and LSM
> to do things correctly:
> 
> - Both TUNSETIFF and TUNSETQUEUE could be used to create the queues of a
> tuntap device.
> - TUNSETQUEUE were used to disable and enable a specific queue of the
>   device. But since the state of tuntap were completely removed from the
> queue, it could be used to attach to another device (there's no such kind
> of requirement currently, and it needs new kind of LSM policy.
> - TUNSETQUEUE could be used to attach to a persistent device without any
>   queues. This kind of attching bypass the necessary checking during
> TUNSETIFF and may lead unexpected result.
> 
> So this patch tries to make a cleaner and simpler API by:
> 
> - Only allow TUNSETIFF to create queues.
> - TUNSETQUEUE could be only used to disable and enabled the queues of a
> device, and the state of the tuntap device were not detachd from the queues
> when it was disabled, so TUNSETQUEUE could be only used after TUNSETIFF and
> with the same device.
> 
> This is done by introducing a list which keeps track of all queues which
> were disabled. The queue would be moved between this list and tfiles[]
> array when it was enabled/disabled. A pointer of the tun_struct were also
> introdued to track the device it belongs to when it was disabled.
> 
> After the change, the isolation between management and application could be
> done through: TUNSETIFF were only called by management software and
> TUNSETQUEUE were only called by application.For LSM/SELinux, the things
> left is to do proper check during tun_set_queue() if needed.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Let me digest these changes and I'll respin the LSM/SELinux multiqueue fixes 
and send them back out for re-discussion/review.

-- 
paul moore
security and virtualization @ redhat

