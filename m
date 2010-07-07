Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab0GGIrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 04:47:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40286 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab0GGIrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 04:47:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 7 Jul 2010 10:46:57 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: cdev: check write quadlet request length to
 avoid buffer overflow
To: Clemens Ladisch <clemens@ladisch.de>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4C29C1CA.1050705@ladisch.de>
Message-ID: <tkrat.cb22c58cc57838c0@s5r6.in-berlin.de>
References: <4C29C1CA.1050705@ladisch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 Jun, Clemens Ladisch wrote at linux1394-devel:
> Check that the data length of a write quadlet request actually is large
> enough for a quadlet.  Otherwise, fw_fill_request could access the four
> bytes after the end of the outbound_transaction_event structure.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> ---
>  drivers/firewire/core-cdev.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/drivers/firewire/core-cdev.c
> +++ b/drivers/firewire/core-cdev.c
> @@ -593,6 +593,9 @@ static int ioctl_send_request(struct cli
>  {
>  	switch (arg->send_request.tcode) {
>  	case TCODE_WRITE_QUADLET_REQUEST:
> +		if (arg->send_request.length < 4)
> +			return -EINVAL;
> +		break;
>  	case TCODE_WRITE_BLOCK_REQUEST:
>  	case TCODE_READ_QUADLET_REQUEST:
>  	case TCODE_READ_BLOCK_REQUEST:
> @@ -1293,6 +1296,9 @@ static int ioctl_send_broadcast_request(
>  
>  	switch (a->tcode) {
>  	case TCODE_WRITE_QUADLET_REQUEST:
> +		if (a->length < 4)
> +			return -EINVAL;
> +		break;
>  	case TCODE_WRITE_BLOCK_REQUEST:
>  		break;
>  	default:

The fix is correct but apparently not urgent.

Here is a listing of struct outbound_transaction_event's definition,
with member sizes in bytes prepended.  First column is on a 32bit
architecture, second column on a 64bit architecture.  Type definitions
are as per 2.6.34.

	struct outbound_transaction_event {
	    struct event {
16  32	        struct { void *data; size_t size; } v[2];
	        struct list_head {
 8  16	            struct list_head *next, *prev;
	        } link;
	    } event;
 4   8	    struct client *client;
	    struct outbound_transaction_resource {
	        struct client_resource {
 4   8	            client_resource_release_fn_t release;
 4   4	            int handle;
	        } resource;
	        struct fw_transaction {
 4   4	            int node_id;
 4   4	            int tlabel;
 4   4	            int timestamp;
	            struct list_head {
 8  16	                struct list_head *next, *prev;
	            } link;
 4   8	            struct fw_card *card;
	            struct timer_list {
	                struct list_head {
 8  16	                    struct list_head *next, *prev;
	                } entry;
 4   8	                unsigned long expires;
 4   8	                void (*function)(unsigned long);
 4   8	                unsigned long data;
 4   8	                struct tvec_base *base;
	            #ifdef CONFIG_TIMER_STATS
 4*  8*	                void *start_site;
16* 16*	                char start_comm[16];
 4*  4*	                int start_pid;
	            #endif
	            #ifdef CONFIG_LOCKDEP
	                struct lockdep_map {
 4* 12*°                    struct lock_class_key *key;
 4*  8*	                    struct lock_class *class_cache;
 4*  8*	                    const char *name;
	                #ifdef CONFIG_LOCK_STAT
 4*  4*	                    int cpu;
 4*  8*	                    unsigned long ip;
	                #endif
	                } lockdep_map;
	            #endif
	            } split_timeout_timer;
	            struct fw_packet {
 4   4	                int speed;
 4   4	                int generation;
16  16	                u32 header[4];
 4   8	                size_t header_length;
 4   8	                void *payload;
 4   8	                size_t payload_length;
 4^  8	                dma_addr_t payload_bus;
 4   4	                bool payload_mapped;
 4   4	                u32 timestamp;
 4   8	                fw_packet_callback_t callback;
 4   4	                int ack;
	                struct list_head {
 8  20°	                    struct list_head *next, *prev;
	                } link;
 4   8	                void *driver_data;
	            } packet;
 4   8	            fw_transaction_callback_t callback;
 4   8	            void *callback_data;
	        } transaction;
	    } r;
	    struct fw_cdev_event_response {
 8   8	        __u64 closure;
 4   4	        __u32 type;
 4   4	        __u32 rcode;
 4   4	        __u32 length;
	        __u32 data[0];
	    } response;
	};

*) =0 if respective debug options are off
°) -4 if the compiler aligns 64bit types at 32bit boundaries
^) =8 if CONFIG_HIGHMEM64G


The total size is therefore
  180 bytes on 32bit without debug options and HIGHMEM64G off
  228 bytes on 32bit with TIMER_STATS, LOCKDEP, LOCK_STAT, and HIGHMEM64G
  292 bytes on 64bit without debug options
  360 bytes on 64bit with TIMER_STATS, LOCKDEP, and LOCK_STAT

Therefore the slab allocator gives us 256 bytes on 32bit and 512 bytes
on 64bit, right?  Or more if the user-requested size of response.data[]
raises the total size above that.  (struct outbound_transaction_event
instances are always kmalloc'ed, never stack-allocated or
kmem_cache-allocated.)  Which in turn means that an access past the
requested size still lands in allocated (though uninitialized) memory.

I.e. nothing bad happens except that random bytes are included into the
quadlet write request packet payload.

(I only ask because I wonder about how to submit this patch or a variant
of it.  Me thinks the post 2.6.35 merge is OK.)
-- 
Stefan Richter
-=====-==-=- -=== --===
http://arcgraph.de/sr/

