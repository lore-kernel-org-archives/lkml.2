Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab1FIOSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:18:42 -0400
Received: from smtp-out.google.com ([74.125.121.67]:20724 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1FIOSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:18:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ljtxJkMjIr69enum4FrXxPbSAqH623FRJSejKD3+xxVJvzI6GDZ0GytIzKbmVFenKS
         8oGXCZuE+i+cwLyIT6sQ==
MIME-Version: 1.0
Date: Thu, 9 Jun 2011 16:18:37 +0200
Message-ID: <BANLkTikcXcfH2OxD9+tTnS6S2svafWq74w@mail.gmail.com>
Subject: [BUG] perf: older perf.data files may not be readable
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

I was looking at util/session.c:

int perf_file_header__read(struct perf_file_header *header,
                           struct perf_header *ph, int fd)
{
        lseek(fd, 0, SEEK_SET);

        if (readn(fd, header, sizeof(*header)) <= 0 ||
            memcmp(&header->magic, __perf_magic, sizeof(header->magic)))
                return -1;

        if (header->attr_size != sizeof(struct perf_file_attr)) {
                u64 attr_size = bswap_64(header->attr_size);

                if (attr_size != sizeof(struct perf_file_attr))
                        return -1;

                mem_bswap_64(header, offsetof(struct perf_file_header,
                                            adds_features));
                ph->needs_swap = true;
        }
        ...
}

struct perf_file_attr {
   struct perf_event_attr attr;
   struct perf_file_section ids;
};

The way you detect endianess leads me to believe that perf will not be
able to cope with growth of perf_event_attr struct AND maintain backward
compatibility with perf.data files saved with smaller perf_event_attr struct.

It should be possible to read perf.data files written with a smaller
perf_event_attr struct. You simply ignore leave the extended fields at zero.

Conversely, you can ignore the fields if the perf.data struct is larger
than that of the tool. But this is the more unlikely scenario, so it's
not that important.
