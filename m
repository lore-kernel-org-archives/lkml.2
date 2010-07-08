Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549Ab0GHToQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 15:44:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54398 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab0GHToN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 15:44:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NeI6cuzePi6idiQIDg7pHNFmKGpP9LjygRf2dpMBMoy8UIlO1z8IAwrYrSDBVsSv1v
         LuMKi41l27Jk8+B4HaqItGpnqN1GaDpwSZ4RRNSTPKc0Kmm8cdPxvmkX+5KgAqG+Tu7/
         yc8wCSm9mJAqNky3AlCn+l9u9ToEG2UwZw/iY=
MIME-Version: 1.0
In-Reply-To: <20100630233614.32422.97038.stgit@warthog.procyon.org.uk>
References: <20100630233614.32422.97038.stgit@warthog.procyon.org.uk>
Date: Thu, 8 Jul 2010 21:44:09 +0200
X-Google-Sender-Auth: iL6HSDoItEXiouU0D5J2uynL4Ak
Message-ID: <AANLkTikP-u1adVItGDgUZdee14Z13k8MLRC5V7UN-gpV@mail.gmail.com>
Subject: Re: [PATCH] Add a pair of system calls to make extended file stats 
	available [ver #3]
From: Michael Kerrisk <mtk.manpages@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       linux-ext4@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

A couple of comments below.

On Thu, Jul 1, 2010 at 1:36 AM, David Howells <dhowells@redhat.com> wrote:
> Add a pair of system calls to make extended file stats available, including
> file creation time, inode version and data version where available through the
> underlying filesystem.
>
> [This depends on the previously posted pair of patches to (a) constify a number
>  of syscall string and buffer arguments and (b) rearrange AFS's use of
>  i_version and i_generation].
>
> The following structures are defined for their use:
>
>        struct xstat_parameters {
>                unsigned long long      request_mask;

Poor name, since it's a value-result arg? Better maybe something like
"field_mask"?

>        };
>
>        struct xstat_dev {
>                unsigned int            major, minor;
>        };
>
>        struct xstat_time {
>                unsigned long long      tv_sec, tv_nsec;
>        };
>
>        struct xstat {
>                unsigned int            st_mode;
>                unsigned int            st_nlink;
>                unsigned int            st_uid;
>                unsigned int            st_gid;
>                struct xstat_dev        st_rdev;
>                struct xstat_dev        st_dev;
>                struct xstat_time       st_atime;
>                struct xstat_time       st_mtime;
>                struct xstat_time       st_ctime;
>                struct xstat_time       st_btime;
>                unsigned long long      st_ino;
>                unsigned long long      st_size;
>                unsigned long long      st_blksize;
>                unsigned long long      st_blocks;
>                unsigned long long      st_gen;
>                unsigned long long      st_data_version;
>                unsigned long long      st_result_mask;
>                unsigned long long      st_extra_results[0];
>        };
>
> where st_btime is the file creation time, st_gen is the inode generation
> (i_generation), st_data_version is the data version number (i_version),
> request_mask and st_result_mask are bitmasks of data desired/provided and
> st_extra_results[] is where as-yet undefined fields are appended.
>
> The defined bits in request_mask and st_result_mask are:
>
>        XSTAT_REQUEST_MODE              Want/got st_mode
>        XSTAT_REQUEST_NLINK             Want/got st_nlink
>        XSTAT_REQUEST_UID               Want/got st_uid
>        XSTAT_REQUEST_GID               Want/got st_gid
>        XSTAT_REQUEST_RDEV              Want/got st_rdev
>        XSTAT_REQUEST_ATIME             Want/got st_atime
>        XSTAT_REQUEST_MTIME             Want/got st_mtime
>        XSTAT_REQUEST_CTIME             Want/got st_ctime
>        XSTAT_REQUEST_INO               Want/got st_ino
>        XSTAT_REQUEST_SIZE              Want/got st_size
>        XSTAT_REQUEST_BLOCKS            Want/got st_blocks
>        XSTAT_REQUEST__BASIC_STATS      The stuff in the normal stat struct
>        XSTAT_REQUEST_BTIME             Want/got st_btime
>        XSTAT_REQUEST_GEN               Want/got st_gen
>        XSTAT_REQUEST_DATA_VERSION      Want/got st_data_version
>        XSTAT_REQUEST__EXTENDED_STATS   The stuff in the xstat struct
>        XSTAT_REQUEST__ALL_STATS        The defined set of requestables
>
> The system calls are:
>
>        ssize_t ret = xstat(int dfd,
>                            const char *filename,
>                            unsigned flags,
>                            const struct xstat_parameters *params,
>                            struct xstat *buffer,
>                            size_t buflen);
>
>        ssize_t ret = fxstat(unsigned fd,
>                             unsigned flags,
>                             const struct xstat_parameters *params,
>                             struct xstat *buffer,
>                             size_t buflen);
>
>
> The dfd, filename, flags and fd parameters indicate the file to query.  There
> is no equivalent of lstat() as that can be emulated with xstat() by passing
> AT_SYMLINK_NOFOLLOW in flags.
>
> AT_FORCE_ATTR_SYNC can also be set in flags.  This will require a network
> filesystem to synchronise its attributes with the server.
>
> When the system call is executed, the request_mask bitmask is read from the
> parameter block to work out what the user is requesting.  If params is NULL,
> then request_mask will be assumed to be XSTAT_REQUEST__GET_ANYWAY.

There is no XSTAT_REQUEST__GET_ANYWAY, AFAICS. I guess here you meant
XSTAT_REQUEST__EXTENDED_STATS? Or?


> The request_mask should be set by the caller to specify extra results that the
> caller may desire.  These come in a number of classes:
>
>  (0) dev, blksize.
>
>     These are local data and are always available.
>
>  (1) mode, nlinks, uid, gid, [amc]time, ino, size, blocks.
>
>     These will be returned whether the caller asks for them or not.  The
>     corresponding bits in result_mask will be set to indicate their presence.
>
>     If the caller didn't ask for them, then they may be approximated.  For
>     example, NFS won't waste any time updating them from the server, unless as
>     a byproduct of updating something requested.
>
>  (2) rdev.
>
>     As for class (1), but this won't be returned if the file is not a blockdev
>     or chardev.  The bit will be cleared if the value is not returned.
>
>  (3) File creation time, inode generation and data version.
>
>     These will be returned if available whether the caller asked for them or
>     not.  The corresponding bits in result_mask will be set or cleared as
>     appropriate to indicate their presence.
>
>     If the caller didn't ask for them, then they may be approximated.  For
>     example, NFS won't waste any time updating them from the server, unless
>     as a byproduct of updating something requested.
>
>  (4) Extra results.
>
>     These will only be returned if the caller asked for them by setting their
>     bits in request_mask.  They will be placed in the buffer after the xstat
>     struct in ascending result_mask bit order.  Any bit set in request_mask
>     mask will be left set in result_mask if the result is available and
>     cleared otherwise.
>
>     The pointer into the results list will be rounded up to the nearest 8-byte
>     boundary after each result is written in.  The size of each extra result
>     is specific to the definition for that result.
>
>     No extra results are currently defined.
>
> If the buffer is insufficiently big, the syscall returns the amount of space it
> will need to write the complete result set and returns a partial result in the
> buffer.

This case is almost certainly a user error, so why not simply return
an error (-1 and ERANGE or E2BIG)? The above approach invites
userspace errors of the form:

if (xtat(...) < 0) { /* How users often check for error */
    /* I'll handle the error */
} else {
    /* The call succeeded; I'm fine */
}

Instead, more complex error-handling is required for *every* call:

ret = xstat(..., buflen);
if (ret < 0 || ret > buflen)
    /* I'll handle the error */
} else {
    /* The call succeeded; I'm fine */
}

If you are looking for a way to inform the user about the required
buffer size, I think it would be better to take a leaf from the
getxattr(2) book: if 'buflen' is zero, then do nothing with the output
arg, but return the size that would be required.

Cheers,

Michael
