Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2AXPma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 10:42:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab2AXPm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 10:42:29 -0500
Date: Tue, 24 Jan 2012 10:42:24 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, Tejun Heo <tejun@google.com>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 14/16] blkcg: don't allow or retain configuration of
 missing devices
Message-ID: <20120124154224.GA17291@redhat.com>
References: <1327360193-24679-1-git-send-email-tj@kernel.org>
 <1327360193-24679-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327360193-24679-15-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 03:09:51PM -0800, Tejun Heo wrote:

[..]
>  static int blkio_policy_parse_and_set(char *buf,
> -	struct blkio_policy_node *newpn, enum blkio_policy_id plid, int fileid)
> +				      struct blkio_policy_node *newpn,
> +				      enum blkio_policy_id plid, int fileid,
> +				      struct blkio_cgroup *blkcg)
>  {
>  	struct gendisk *disk = NULL;
> +	struct blkio_group *blkg = NULL;
>  	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
>  	unsigned long major, minor;
>  	int i = 0, ret = -EINVAL;
> @@ -868,12 +871,19 @@ static int blkio_policy_parse_and_set(char *buf,
>  		goto out;
>  
>  	/* For rule removal, do not check for device presence. */
> -	if (temp) {
> -		disk = get_gendisk(dev, &part);
> -		if (!disk || part) {
> -			ret = -ENODEV;
> -			goto out;
> -		}
> +	disk = get_gendisk(dev, &part);
> +
> +	if ((!disk || part) && temp) {
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +
> +	rcu_read_lock();
> +
> +	if (disk && !part) {
> +		spin_lock_irq(disk->queue->queue_lock);
> +		blkg = blkg_lookup_create(blkcg, disk->queue, plid);
> +		spin_unlock_irq(disk->queue->queue_lock);

If queue is in bypass mode, is group creation and linking allowed when
somebody is trying to set per device rules. (/me is thinking if there are
any potential races between elevator switch and rule setting in cgroup).

Thanks
Vivek
