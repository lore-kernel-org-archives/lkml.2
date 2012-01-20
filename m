Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2ATLMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 06:12:51 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:36788 "HELO nudt.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751546Ab2ATLMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 06:12:48 -0500
Date: Fri, 20 Jan 2012 19:00:02 +0800
From: "Li Wang" <liwang@nudt.edu.cn>
Subject: Re:Re: [PATCH] eCryptfs: truncate optimization (sometimes upto 25
 000x   fa ster)
To: dustin.kirkland@gazzang.com, torvalds@linux-foundation.org,
        ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Cong Wang" <xiyou.wangcong@gmail.com>,
        john.johansen@canonical.com, akpm@linux-foundation.org,
        "Tyler Hicks" <tyhicks@canonical.com>
References: <1201191719207c1a8e2a0d7a3f1e88c2fb8597295f6d@nudt.edu.cn>
 <526986075.22208@eyou.net>
In-Reply-To: <526986075.22208@eyou.net>
Message-Id: <1201201900027899fb5c49a2d6e23ac45af901a32fa1@nudt.edu.cn>
MIME-Version: 1.0
X-Mailer: eYou WebMail 5.0.3
X-Eyou-Client: 218.88.164.29
Content-Type: text/plain;
 charset="GBK"
X-Eyou-Sender: <liwang@nudt.edu.cn>
X-Eyou-MID: <dbb02bb845c48fd66542a1447dde0bc0>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0KBCs7t004426

Hi Tyler,
  Thanks for your comments. I agree with that the plaintext inode size
is __fragile__, because its consistence can hardly be protected by the lower
file system, even the journal is supported. Since the eCryptfs
metadata are just normal file data seen from lower file system,
the lower file system is not easy to treat several data pages (include
eCryptfs metadata update and file data write) together as a journal
transaction.
  However, I am not quite convinced by the performance argue. For current
implementation, it incurs too heavy startup cost. Some applications,
for example, as far as I know, for the older version Samba server (I am not quite
sure about the latest version), when exporting eCryptfs plain text folder by Samba
to the Windows client, if you upload a big file through the Windows Samba client,
the Samba server will first truncate to generate an empty file, then start write.
It just costs too much time to create that big file, user as well as Samba totally
does not know what is going on. Sometimes Samba even gives up the upload
because of too much time of waiting, which is incorrectly treated as a network
connection timeout. With this truncate optimization, the cost is averaged, the file
is expanded on-demand, the user experience is improved (at least, both user and
Samba knows that the write is going on instead of no response from kernel at all).  





---------- Origin message ----------
>From£º"Tyler Hicks" <tyhicks@canonical.com>
>To£º"Li Wang" <liwang@nudt.edu.cn>
>Subject£ºRe: [PATCH] eCryptfs: truncate optimization (sometimes upto 25000x fa ster)
>Date£º2012-01-19 23:26:55

On 2012-01-19 17:19:20, Li Wang wrote:
> Hi,
> Many modern disk-based file systems, such as ext4,
> have the truncate optimization feature, kind of delayed allocation, that is,
> when using 'truncate' to produce a big empty file, the file system will not
> allocate disk space until real data are written into, as a result,
> the execution of truncate is very fast and the disk space are saved.
> However, for eCryptfs, it will actually create a equal-size file, and write zeroes into it,
> which results in the allocation of disk space and slow disk write operations.
> Since eCryptfs does not record hole information on disk, therefore,
> when read out a page of zeroes, eCryptfs can not distinguish actual data
> (encrypted data happened to be whole zeroes) from hole,
> therefore, eCryptfs can not rely on the lower file system specific truncate implementation.
> However, there is one thing eCryptfs can do is that eCryptfs does record file size itself
> on the disk, so that it could be aware of the hole at the end of the file.
> The natural optimization is, while truncate to expand a file to exceed the original size
> (which occurs in many cases while doing truncate),
> record the actual file size (after expansion) in the eCryptfs metadata,
> keep the original size unchanged in the lower file system.
> When reading, if the file size seen from eCryptfs is bigger than from ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
