Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305Ab0E1KAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:00:55 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:45029 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172Ab0E1KAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:00:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=yG3GFI9keATUeOYYgUM66/1ilrEhHb+p4hsjgqZv0DCOrxWoAC0mMfn+AMnoEisQjl
         5aqF/Fi7qg56XXOlYeEjcpjgaw7pduzvA2/lQ22XpbOO5SOM/QCAe4aQsrGd/mXM5OoL
         Cq9c8zL7emfOSekvIhP88LYHTSp2kyoEJLS6Y=
MIME-Version: 1.0
In-Reply-To: <E1OHw5Q-00020q-Dk@pomaz-ex.szeredi.hu>
References: <1274885083-15735-1-git-send-email-xiaosuo@gmail.com> 
	<E1OHw5Q-00020q-Dk@pomaz-ex.szeredi.hu>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 28 May 2010 18:00:32 +0800
Message-ID: <AANLkTill8Y1RNTzZ9BFmVHPxLyx7CZIL5okqUCRVrrmH@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] splice: fix updating sd->pos wrongly
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: axboe@kernel.dk, viro@zeniv.linux.org.uk, mszeredi@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 5:42 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, 26 May 2010, Changli Gao wrote:
>> fix updating sd->pos wrongly.
>>
>> In error path, we don't need to updating sd->pos, if the file isn't seekable.
>
> This patch is nonsense.  Why should we handle sd->pos != 0 case
> differently?
>

If the in file isn't seekable, its splice_read won't update *ppos, so
in the error path, we'd better not change it too. Otherwise, some
assumption will go wrong.

ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
                        struct pipe_inode_info *pipe, size_t len,
                        unsigned int flags)
{
        struct sock *sk = sock->sk;
        struct tcp_splice_state tss = {
                .pipe = pipe,
                .len = len,
                .flags = flags,
        };
        long timeo;
        ssize_t spliced;
        int ret;

        /*
         * We can't seek on a socket input
         */
        if (unlikely(*ppos))
                return -ESPIPE;


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
