Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1AQEdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 23:33:15 -0500
Received: from qmta04.westchester.pa.mail.comcast.net ([76.96.62.40]:55283
	"EHLO qmta04.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191Ab1AQEdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 23:33:14 -0500
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Jan 2011 23:33:14 EST
Message-ID: <4D33C527.3020005@tilera.com>
Date: Sun, 16 Jan 2011 23:27:19 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
Newsgroups: linux-arch
To: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic headers: modify stat.h in include/asm-generic
 to be applicable to more architectures
References: <024501cbaf37$4e479fd0$ead6df70$@mprc.pku.edu.cn> <201101090128.25371.arnd@arndb.de> <lapr25MsLHA.5972@exchange1.tad.internal.tilera.com>
In-Reply-To: <lapr25MsLHA.5972@exchange1.tad.internal.tilera.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2011 8:58 AM, Guan Xuetao wrote:
> IMO, asm-generic headers should be used in more architectures as far as possible.
> The patch of stat.h could be split into two parts to discuss.
> [...]
> Secondly, STAT64_PAD_BEFORE_* are misunderstanding definitions, and perhaps
> it should use STAT64_ST_SIZE_NEED_ALIGN_64.
> Indeed, the macros are used for compatibility, but most architectures could make full use of
> asm-generic headers, and new architectures could just follow the default values.

Other than the issue with 32-bit time_t (as mentioned by Arnd elsewhere in
this thread) the Tilera architecture happily uses the existing
<asm-generic/stat.h>.  I have a proposed "generic kernel ABI" version of
<bits/stat.h> for glibc which includes the appended code.  This is a little
peculiar but essentially allows all the permutations of 64-bit, old-school
32-bit, and 32-bit with __USE_FILE_OFFSET64 to work correctly, taking into
account the endianness of the platform, and allows glibc to have equivalent
definitions of its "kernel stat" and "user stat" structures, thus avoiding
having to do a field-by-field copy.

[...]
#if defined(__USE_FILE_OFFSET64)
# define __field64(type,type64,name,n) type64 name
#elif __WORDSIZE == 64
# define __field64(type,type64,name,n) type name
#elif __BYTE_ORDER == __LITTLE_ENDIAN
# define __field64(type,type64,name,n) \
  type name __attribute__((aligned(8))); int __pad##n
#else
# define __field64(type,type64,name,n) \
  int __pad##n __attribute__((aligned(8))); type name
#endif

struct stat
  {
    __dev_t st_dev;             /* Device.  */
    __field64(__ino_t, __ino64_t, st_ino, 0);  /* File serial number. */
    __mode_t st_mode;           /* File mode.  */
    __nlink_t st_nlink;         /* Link count.  */
    __uid_t st_uid;             /* User ID of the file's owner. */
    __gid_t st_gid;             /* Group ID of the file's group.*/
    __dev_t st_rdev;            /* Device number, if device.  */
    __dev_t __pad1;
    __field64(__off_t, __off64_t, st_size, 2);  /* Size of file. */
    __blksize_t st_blksize;     /* Optimal block size for I/O.  */
    int __pad3;
    __field64(__blkcnt_t, __blkcnt64_t, st_blocks, 4);  /* Blocks */
#ifdef __USE_MISC
    /* Nanosecond resolution timestamps are stored in a format
       equivalent to 'struct timespec'.  This is the type used
       whenever possible but the Unix namespace rules do not allow the
       identifier 'timespec' to appear in the <sys/stat.h> header.
       Therefore we have to handle the use of this header in strictly
       standard-compliant sources special.  */
    struct timespec st_atim;            /* Time of last access.  */
    struct timespec st_mtim;            /* Time of last modification.  */
    struct timespec st_ctim;            /* Time of last status change.  */
# define st_atime st_atim.tv_sec        /* Backward compatibility.  */
# define st_mtime st_mtim.tv_sec
# define st_ctime st_ctim.tv_sec
#else
    __time_t st_atime;                  /* Time of last access.  */
    unsigned long int st_atimensec;     /* Nscecs of last access.  */
    __time_t st_mtime;                  /* Time of last modification.  */
    unsigned long int st_mtimensec;     /* Nsecs of last modification.  */
    __time_t st_ctime;                  /* Time of last status change.  */
    unsigned long int st_ctimensec;     /* Nsecs of last status change.  */
#endif
    int __unused[2];
  };

#undef __field64
[...]

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
