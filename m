Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2HBV1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 17:27:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab2HBV1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 17:27:50 -0400
Message-ID: <501AF0CC.6010903@suse.de>
Date: Thu, 02 Aug 2012 17:27:40 -0400
From: Jeff Mahoney <jeffm@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Subject: Re: R.I.P. pdflush
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 7/25/12 11:11 AM, Artem Bityutskiy wrote:
> For example, reiserfs deadlocked quickly when I tested it using
> xfstests with resierfs quota support enabled. I spend several days
> trying to fix this, but reiserfs is quite complex and I'd say its
> locking is crazy (partially because of the BKL push-down). But I
> gave up after I realized that the dead-lock is related to the quota
> support. I disabled quotas and xfstests passed.

Thanks for mentioning this. This is due to both reiserfs_write_dquot
and reiserfs_evict_inode taking the reiserfs_write_lock. The old
reiserfs locking code depended on the recursive locking ability of the
BKL and the push-down made that a special case. This case isn't
handled so even though the write lock is supposed to be dropped to
take the journal lock safely, it's not and we end up with an ABBA case
there.

I'll work up a fix.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQGvDMAAoJEB57S2MheeWy+zMQAKUwXaF7O2WyDfl3B3/2tL6b
f+Q1BPkgD7UIgjJ9wnakb4F72+k79gLGq11V39MXfrBKnzQAgprb5Ll9eUNl1f9x
9KgAkeKQTYowYpUXfuLZUzevAX5Ys6dB3+XOWhgTaVc/L0TTgKc7aET5JotDTJM4
V6SiKcb2uqDrEk5IAo/t3pfxaSe1gOYkZWfxSOzG1l3Kp5HHJ5B6Ya4Nx5Qw2llM
Vt6fK0KLjN2kqmv80SlHRy7vOnhM1EAOrkzNuzGmdDPgAk1nBJnB8oO9W3x6WFO+
Tsc5KbiJss6Nf0dHbyNNX1hJpnyJr9kBGrVADLMZEXIqGp3eIgIy04W/QV2fvWOz
650aogYvY44mEC+55jV5RD2ubBfBhROazJsrLN4ACKIjo3KE6P/50vD8Pi9gH/F+
rq15ytztlroF3M6ejVVjfTK5BOlx+H1bIrat06aBHsyWXTcNoLpa32z6BVhldrc6
a/XdKP0CwKtIRcvr8f8zg4PHLoejaTXULJnNSQyDrIzXLz08kkEK6nxe3q1+Mp+a
uH9y6y9SToaCPcLZUT9vInnmvxL/qV/uvspPDXFsZDAMAmfFVycpwGybiuTt5Y2T
vCzOJVcCodX1cONiYfMrlNfqRGFewi0GCYTtMaz9Z1zOE9C1fwLeBorkUigxzIzT
M6uA+edSRUBjg45r1EaR
=oelZ
-----END PGP SIGNATURE-----
