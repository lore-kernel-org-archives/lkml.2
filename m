Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab2AEXuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:50:17 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62402 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144Ab2AEXuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:50:15 -0500
MIME-Version: 1.0
In-Reply-To: <4F05A332.1060600@redhat.com>
References: <1324576939-23619-3-git-send-email-pbonzini@redhat.com>
 <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
 <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com>
 <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com>
 <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com>
 <20111222234830.GC31021@agk-dp.fab.redhat.com> <CA+55aFxqy1wJFFVbykBJWuGm8YAjA-VP=xAqHttVOwC_zuxvOA@mail.gmail.com>
 <20111223062649.GD21994@1wt.eu> <CA+55aFxnOwkquH8tirqJnM_KTcavAejY8drL11jy2S+2PXmZuw@mail.gmail.com>
 <4EF48CE4.3000104@redhat.com> <CA+55aFy=7wGzQv76dirJ=ZjeNdbKVKDRCLA323orsE13GcKvwQ@mail.gmail.com>
 <4F05A332.1060600@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jan 2012 15:49:53 -0800
X-Google-Sender-Auth: bArwTIinoYqKbmnk8DcbSLb5wSs
Message-ID: <CA+55aFw8+vGbkTquC8kjTPTRF1fXC8LNU0TcVq-EPmHataPWPg@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 5:18 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Would you apply the patches as they are or do you want me to squash in
> something like this?
>
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index a6bedfe..bb94c88 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -710,6 +710,14 @@ int scsi_verify_blk_ioctl(struct block_device *bd, unsigned int cmd)
>        case SG_SET_RESERVED_SIZE:
>        case SG_EMULATED_HOST:
>                return 0;
> +
> +       case CDROMEJECT:
> +               /* This is also unsafe for partition devices, but
> +                * "eject /mnt/usb-drive" invokes it.  Warn about it
> +                * and keep backwards compatibility.  */
> +               printk_ratelimited(KERN_WARNING
> +                                  "sending CDROMEJECT ioctl to a partition\n");
> +               return 0;
>        default:
>                break;
>        }

I think that right now the right thing to do woult probably to

 (a) print that warning - naming the actual ioctl number - for *every*
ioctl this disallows.

 (b) after warning, let them through for CAP_SYS_RAWIO, so that if
there are users of them, we will both know about them, _and_ we will
avoid breaking them if there are no security issues.

Hmm? Can you send such an updated patch, and we can get this in early
in the merge window, and start testing? I committed and pushed out the
ENOIOCTLCMD cleanup, let's see if that causes any problems..

                      Linus
