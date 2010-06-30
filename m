Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab0F3IbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:31:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49286 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0F3IbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:31:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 10:30:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
References: <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <20100630011712.18960.3723.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100630011712.18960.3723.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006301030.52235.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+hvhwYLTm19uOKuUkqzVEoAVU611Hn4SA3QHK
 o4cRPKcy9xvg0RHipxMaZttYfirYCUbMpa7N2QI8MO8EKMXVNJ
 WO0GzfBfU+MYn8z79UsGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 June 2010 03:17:12 David Howells wrote:
> +static int xstat_check_param(struct xstat __user *buffer, size_t bufsize,
> +                            struct kstat *stat)
> +{
> +       u32 struct_version;
> +       int ret;
> +
> +       /* if the buffer isn't large enough, return how much we wanted to
> +        * write, but otherwise do nothing */
> +       if (bufsize < sizeof(struct xstat))
> +               return sizeof(struct xstat);
> +
> +       ret = get_user(struct_version, &buffer->struct_version);
> +       if (ret < 0)
> +               return ret;
> +       if (struct_version != 0)
> +               return -ENOTSUPP;
> +
> +       memset(stat, 0xde, sizeof(*stat));
> +
> +       ret = get_user(stat->query_flags, &buffer->query_flags);
> +       if (ret < 0)
> +               return ret;
> +
> +       /* nothing outside this set has a defined purpose */
> +       stat->query_flags &= XSTAT_QUERY__DEFINED_SET;
> +       stat->result_flags = 0;
> +       return 0;
> +}

I think it would be better to leave the structure as write-only from
the kernel and pass the query_flags and struct_version as syscall
arguments, though it makes sense to store them in the result as well.

Independent from this, I also think that we can collapse the
struct_version into the more flexible query_flags. When the structure
gets extended with new fields, just add another flag to let
the user ask for them.

When the flags are outside of the structure, you can even have a flag
that will result in a completely new structure layout to be returned.

	Arnd
