Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab0EYQLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:11:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31831 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab0EYQLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:11:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=duL6YEhyGoB1CCbIdm2raHB5UDwhRV1rq+VdJKzyqWjygerprIy6dR8hwWfhQB0H3
	b2dh5KHvt2MrEzoVShHeA==
MIME-Version: 1.0
In-Reply-To: <20100525160550.GC28588@agk-dp.fab.redhat.com>
References: <1274802411-26613-1-git-send-email-wad@chromium.org>
	<1274802411-26613-2-git-send-email-wad@chromium.org>
	<20100525155535.GA811@infradead.org>
	<20100525160550.GC28588@agk-dp.fab.redhat.com>
Date: Tue, 25 May 2010 11:11:33 -0500
X-Google-Sender-Auth: rc2r-p1aD1FSgcddlDvjDOu48xY
Message-ID: <AANLkTin6Nt2TqxlF9kQJZThI7pZ6wqAwSlg9GnqkKB-v@mail.gmail.com>
Subject: Re: [PATCH 2/2] init, mount: export the name_to_dev_t symbol
From: Will Drewry <wad@chromium.org>
To: Alasdair G Kergon <agk@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@suse.de>,
       Tejun Heo <tj@kernel.org>, Scott James Remnant <scott@ubuntu.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Harald Hoyer <harald@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, snitzer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 11:05 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Tue, May 25, 2010 at 11:55:35AM -0400, Christoph Hellwig wrote:
>> NACK.  It's really a hack for the boot code, there's no offical name to
>> dev_t mapping.
>> What are you trying to use it for?
>
> Device-mapper contains a subset of that code, so he's proposing we
> use it here:
>
> @@ -434,17 +435,13 @@ static int __table_get_device(struct dm_
>        int r;
>        dev_t uninitialized_var(dev);
>        struct dm_dev_internal *dd;
> -       unsigned int major, minor;
>
>        BUG_ON(!t);
>
> -       if (sscanf(path, "%u:%u", &major, &minor) == 2) {
> -               /* Extract the major/minor numbers */
> -               dev = MKDEV(major, minor);
> -               if (MAJOR(dev) != major || MINOR(dev) != minor)
> -                       return -EOVERFLOW;
> -       } else {
> -               /* convert the path to a device */
> +       /* lookup by major:minor or registered device name */
> +       dev = name_to_dev_t(path);
> +       if (!dev) {
> +               /* convert the path to a device by finding its inode */
>                struct block_device *bdev = lookup_bdev(path);
>
>                if (IS_ERR(bdev))

In addition to getting rid of the code duplication, I'd like device-mapper
to be able to resolve slave devices at boot-time to accommodate a
do_mounts_dm.c equivalent to do_mounts_md.c:

  https://patchwork.kernel.org/patch/101024/

(which I neglected to mail to the other init-related maintainers - sorry!
 I'll correct that when I mail out the next revision.)

thanks!
will
